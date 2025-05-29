defmodule GersangDbWeb.RecipeLive.Index do
  use GersangDbWeb, :live_view

  alias GersangDb.Gersang.Recipes
  alias GersangDb.Domain.Recipe
  alias GersangDb.GersangItem

  @impl true
  def mount(_params, _session, socket) do
    gersang_item_options = Enum.map(GersangItem.list_items(), fn item -> {item.name, item.id} end)

    recipes = Recipes.list_recipes()

    # Group recipes by product, then by media, and aggregate material items
    grouped_recipes =
      recipes
      |> Enum.group_by(& &1.product_item)
      |> Enum.map(fn {product, product_recipes} ->
        # Get all unique materials for this product across all media
        all_materials =
          product_recipes
          |> Enum.map(& &1.material_item)
          |> Enum.uniq_by(& &1.id)
          |> Enum.sort_by(& &1.name)

        # Calculate total cost and summation display
        {total_cost, cost_breakdown} = calculate_product_cost(all_materials)

        by_media =
          product_recipes
          |> Enum.group_by(& &1.media)
          |> Enum.map(fn {media, media_recipes} ->
            material_items =
              media_recipes
              |> Enum.map(& &1.material_item)
              |> Enum.uniq_by(& &1.id)
              |> Enum.sort_by(& &1.name)
            %{media: media, materials: material_items}
          end)
        %{product: product, by_media: by_media, total_cost: total_cost, cost_breakdown: cost_breakdown}
      end)

    socket =
      socket
      |> assign(:grouped_recipes, grouped_recipes)
      |> assign(:gersang_item_options, gersang_item_options)
      |> stream(:gersang_recipes, recipes)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"product_id" => product_id, "media" => media}) do
    recipes = Recipes.list_recipes_by_product_and_media(product_id, media)
    socket
    |> assign(:page_title, "Edit Recipe")
    |> assign(:gersang_recipes, recipes)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe")
    |> assign(:gersang_recipes, [])
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipes")
    |> assign(:gersang_recipe, nil)
  end

  @impl true
  def handle_event("delete", %{"product_id" => product_id, "media" => media}, socket) do
    # Delete all recipes with the given product_id and media
    import Ecto.Query
    from(r in Recipe, where: r.product_item_id == ^product_id and r.media == ^media)
    |> GersangDb.Repo.delete_all()
    # Remove all from the stream
    updated_stream =
      Enum.reject(
        socket.assigns.streams.gersang_recipes[:entries],
        fn r ->
          to_string(r.product_item_id) == to_string(product_id) and r.media == media
        end
      )
    {:noreply, stream(socket, :gersang_recipes, updated_stream)}
  end

  @impl true
  def handle_info({GersangDbWeb.RecipeLive.FormComponent, {:saved, recipe}}, socket) do
    {:noreply, stream_insert(socket, :gersang_recipes, recipe)}
  end
  # Helper function to calculate total cost and create breakdown string
  defp calculate_product_cost(materials) do
    materials_with_prices =
      materials
      |> Enum.filter(& &1.market_price)
      |> Enum.map(&{&1.name, &1.market_price})

    case materials_with_prices do
      [] ->
        {0, "No prices available"}
      prices ->
        total = Enum.reduce(prices, 0, fn {_name, price}, acc -> acc + price end)
        breakdown =
          prices
          |> Enum.map(fn {_name, price} -> format_number_with_commas(price) end)
          |> Enum.join(" + ")

        formatted_total = format_number_with_commas(total)
        abbreviated = format_abbreviated_number(total)

        total_display = case abbreviated do
          nil -> formatted_total
          abbrev -> "#{formatted_total} (#{abbrev})"
        end

        {total, "#{breakdown} = #{total_display}"}
    end
  end

  # Helper function to format numbers with commas
  defp format_number_with_commas(number) when is_integer(number) do
    number
    |> Integer.to_string()
    |> String.reverse()
    |> String.replace(~r/(\d{3})(?=\d)/, "\\1,")
    |> String.reverse()
  end
  # Helper function to format abbreviated numbers for large values
  defp format_abbreviated_number(number) when number >= 1_000_000_000 do
    abbreviated = number / 1_000_000_000
    formatted = :erlang.float_to_binary(abbreviated, decimals: 3)
    trimmed = String.replace(formatted, ~r/\.?0+$/, "")
    trimmed <> "B"
  end

  defp format_abbreviated_number(number) when number >= 1_000_000 do
    abbreviated = number / 1_000_000
    formatted = :erlang.float_to_binary(abbreviated, decimals: 3)
    trimmed = String.replace(formatted, ~r/\.?0+$/, "")
    trimmed <> "M"
  end

  defp format_abbreviated_number(_number), do: nil
end

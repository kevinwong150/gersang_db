defmodule GersangDbWeb.RecipeLive.Index do
  use GersangDbWeb, :live_view

  alias GersangDbWeb.Utils.ViewHelpers
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
        all_materials_with_amounts =
          product_recipes
          |> Enum.map(fn recipe ->
            %{item: recipe.material_item, amount: recipe.material_amount}
          end)
          # Note: If a material appears in multiple recipes for the same product (e.g. different media),
          # this will list it multiple times. The cost calculation should handle this correctly if needed,
          # or the logic here might need adjustment based on desired behavior for "all_materials" cost.

        # Calculate total cost and summation display using materials with their amounts
        {total_cost, cost_breakdown} = calculate_product_cost(all_materials_with_amounts)

        by_media =
          product_recipes
          |> Enum.group_by(& &1.media)
          |> Enum.map(fn {media, media_recipes} ->
            material_items_with_amounts =
              media_recipes
              |> Enum.map(fn recipe ->
                %{item: recipe.material_item, amount: recipe.material_amount, market_price: recipe.material_item.market_price, name: recipe.material_item.name}
              end)
              |> Enum.uniq_by(& &1.item.id)
              |> Enum.sort_by(& &1.item.name)
            %{media: media, materials: material_items_with_amounts}
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
  defp calculate_product_cost(materials_with_amounts) do
    materials_for_costing =
      materials_with_amounts
      |> Enum.filter(fn %{item: material, amount: _amount} -> material.market_price && material.market_price > 0 end)
      |> Enum.map(fn %{item: material, amount: amount} ->
        %{name: material.name, total_price: material.market_price * amount}
      end)

    case materials_for_costing do
      [] ->
        {0, "No prices available"}
      priced_materials ->
        total = Enum.reduce(priced_materials, 0, fn material, acc -> acc + material.total_price end)
        breakdown =
          priced_materials
          |> Enum.map(fn material -> "#{ViewHelpers.format_number_with_commas(material.total_price)}" end)
          # |> Enum.map(fn material -> "#{material.name} (#{ViewHelpers.format_number_with_commas(material.total_price)})" end)
          |> Enum.join(" + ")

        formatted_total = ViewHelpers.format_number_with_commas(total)
        abbreviated = format_abbreviated_number(total)

        total_display = case abbreviated do
          nil -> formatted_total
          abbrev -> "#{formatted_total} (#{abbrev})"
        end

        {total, "#{breakdown} = #{total_display}"}
    end
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

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

    grouped_recipes = build_grouped_recipe(recipes)

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
  def format_abbreviated_number(number) when number >= 1_000_000_000 do
    abbreviated = number / 1_000_000_000
    formatted = :erlang.float_to_binary(abbreviated, decimals: 3)
    trimmed = String.replace(formatted, ~r/\.?0+$/, "")
    trimmed <> "B"
  end

  def format_abbreviated_number(number) when number >= 1_000_000 do
    abbreviated = number / 1_000_000
    formatted = :erlang.float_to_binary(abbreviated, decimals: 3)
    trimmed = String.replace(formatted, ~r/\.?0+$/, "")
    trimmed <> "M"
  end

  def format_abbreviated_number(_number), do: nil

  def build_grouped_recipe(recipes, product_id \\ nil) do
    recipes
    |> Enum.group_by(& &1.product_item)
    |> Enum.map(fn {product, product_recipes} ->
      all_materials_with_amounts_for_product =
        product_recipes
        |> Enum.map(fn recipe ->
          %{item: recipe.material_item, amount: recipe.material_amount}
        end)

      {total_cost, cost_breakdown} = calculate_product_cost(all_materials_with_amounts_for_product)

      by_media =
        product_recipes
        |> Enum.group_by(& &1.media)
        |> Enum.map(fn {media, media_recipes} ->
          materials_with_amounts_for_media =
            media_recipes
            |> Enum.map(fn recipe ->
              %{item: recipe.material_item, amount: recipe.material_amount}
            end)
            |> Enum.uniq_by(fn material_info -> material_info.item.id end)
            |> Enum.sort_by(fn material_info -> material_info.item.name end)

          %{media: media, materials: materials_with_amounts_for_media}
        end)
        |> Enum.sort_by(& &1.media)

      %{
        product: product,
        by_media: by_media,
        total_cost: total_cost,
        cost_breakdown: cost_breakdown
      }
    end)
    |> then(fn grouped_recipes ->
      if not is_nil(product_id) do
        grouped_recipes
        |> Enum.find(fn item ->
          if not is_nil(product_id) do
            item.product.id == product_id
          else
            true
          end
        end)
      else
        grouped_recipes
      end
    end)
  end
end

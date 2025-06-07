defmodule GersangDbWeb.RecipeLive.Index do
  use GersangDbWeb, :live_view

  alias GersangDb.Repo
  alias GersangDbWeb.Utils.ViewHelpers
  alias GersangDb.Gersang.Recipes
  alias GersangDb.RecipeSpecs
  alias GersangDb.Domain.Recipe
  alias GersangDb.GersangItem

  @impl true
  def mount(_params, _session, socket) do
    gersang_item_options = Enum.map(GersangItem.list_items(), fn item -> {item.name, item.id} end)

    recipes =
      Recipes.list_recipes()
      |> Repo.preload([:product_item, :recipe_spec])

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
  defp apply_action(socket, :edit, %{"product_id" => product_id, "recipe_spec_id" => recipe_spec_id}) do
    recipe_spec = GersangDb.RecipeSpecs.get_recipe_spec!(recipe_spec_id)
    recipes = Recipes.list_recipes_by_product_and_recipe_spec(product_id, recipe_spec_id)
    socket
    |> assign(:page_title, "Edit Recipe")
    |> assign(:gersang_recipes, recipes)
    |> assign(:recipe_spec, recipe_spec)
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
  def handle_event("delete", %{"product_id" => product_id, "recipe_spec_id" => recipe_spec_id}, socket) do
    # Delete all recipes with the given product_id and recipe_spec_id
    import Ecto.Query
    from(r in Recipe, where: r.product_item_id == ^product_id and r.recipe_spec_id == ^recipe_spec_id)
    |> GersangDb.Repo.delete_all()

    # Remove all from the stream
    updated_stream =
      Enum.reject(
        socket.assigns.streams.gersang_recipes[:entries],
        fn r ->
          to_string(r.product_item_id) == to_string(product_id) and to_string(r.recipe_spec_id) == to_string(recipe_spec_id)
        end
      )
    {:noreply, stream(socket, :gersang_recipes, updated_stream)}
  end

  @impl true
  def handle_info({GersangDbWeb.RecipeLive.FormComponent, {:saved, recipe}}, socket) do
    {:noreply, stream_insert(socket, :gersang_recipes, recipe)}
  end  # Helper function to calculate total cost and create breakdown string
  defp calculate_product_cost(materials_with_amounts, production_fees \\ [], production_amounts \\ []) do
    materials_for_costing =
      materials_with_amounts
      |> Enum.filter(fn %{item: material, amount: _amount} -> material.market_price && material.market_price > 0 end)
      |> Enum.map(fn %{item: material, amount: amount} ->
        %{name: material.name, total_price: material.market_price * amount}
      end)

    total_production_fees = Enum.sum(production_fees)
    # Use the minimum production amount (if multiple recipes exist for the same product)
    effective_production_amount = case production_amounts do
      [] -> 1
      amounts -> Enum.min(amounts)
    end

    case materials_for_costing do
      [] when total_production_fees == 0 ->
        {0, "No prices available"}
      [] ->
        total_before_division = total_production_fees
        total = total_before_division / effective_production_amount
        formatted_total = ViewHelpers.format_number_with_commas(total)
        abbreviated = format_abbreviated_number(total)

        total_display = case abbreviated do
          nil -> formatted_total
          abbrev -> "#{formatted_total} (#{abbrev})"
        end

        production_fee_breakdown = ViewHelpers.format_number_with_commas(total_production_fees)
        equation = if effective_production_amount > 1 do
          "(#{production_fee_breakdown}) / #{effective_production_amount} = #{total_display}"
        else
          "#{production_fee_breakdown} = #{total_display}"
        end
        {total, equation}
      priced_materials ->
        materials_total = Enum.reduce(priced_materials, 0, fn material, acc -> acc + material.total_price end)
        total_before_division = materials_total + total_production_fees
        total = total_before_division / effective_production_amount

        materials_breakdown =
          priced_materials
          |> Enum.map(fn material -> "#{ViewHelpers.format_number_with_commas(material.total_price)}" end)
          |> Enum.join(" + ")

        breakdown_before_division = if total_production_fees > 0 do
          production_fee_part = ViewHelpers.format_number_with_commas(total_production_fees)
          "#{materials_breakdown} + #{production_fee_part}"
        else
          materials_breakdown
        end

        formatted_total = ViewHelpers.format_number_with_commas(total)
        abbreviated = format_abbreviated_number(total)

        total_display = case abbreviated do
          nil -> formatted_total
          abbrev -> "#{formatted_total} (#{abbrev})"
        end

        equation = "(#{breakdown_before_division}) / #{effective_production_amount} = #{total_display}"

        {total, equation}
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
        end)      # Collect production fees from all recipe specs for this product
      production_fees =
        product_recipes
        |> Enum.map(fn recipe -> recipe.recipe_spec.production_fee || 0 end)
        |> Enum.uniq()

      # Collect production amounts from all recipe specs for this product
      production_amounts =
        product_recipes
        |> Enum.map(fn recipe -> recipe.recipe_spec.production_amount || 1 end)
        |> Enum.uniq()

      {total_cost, cost_breakdown} = calculate_product_cost(all_materials_with_amounts_for_product, production_fees, production_amounts)

      by_media =
        product_recipes
        |> Enum.group_by(& &1.recipe_spec.media)
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

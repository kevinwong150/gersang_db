defmodule GersangDbWeb.RecipeLive.Show do
  use GersangDbWeb, :live_view

  alias GersangDbWeb.Utils.ViewHelpers
  alias GersangDb.Gersang.Recipes
  alias GersangDb.GersangItem
  alias GersangDb.Domain.Recipe

  @impl true
  def mount(%{"product_id" => product_id, "media" => media_param}, _session, socket) do
    all_recipes = Recipes.list_recipes()
    gersang_item_options = Enum.map(GersangItem.list_items(), fn item -> {item.name, item.id} end)

    target_product_id = String.to_integer(product_id)

    grouped_recipes =
      all_recipes
      |> Enum.group_by(& &1.product_item)
      |> Enum.map(fn {product, product_recipes} ->
        all_unique_materials_for_product =
          product_recipes
          |> Enum.map(& &1.material_item)
          |> Enum.uniq_by(& &1.id)
          |> Enum.sort_by(& &1.name)

        {total_cost, cost_breakdown} = calculate_product_cost(all_unique_materials_for_product)

        by_media =
          product_recipes
          |> Enum.group_by(& &1.media)
          |> Enum.map(fn {media, media_recipes} ->
            material_items_for_media =
              media_recipes
              |> Enum.map(& &1.material_item)
              |> Enum.uniq_by(& &1.id)
              |> Enum.sort_by(& &1.name)
            %{media: media, materials: material_items_for_media}
          end)
          |> Enum.sort_by(& &1.media)

        %{
          product: product,
          by_media: by_media,
          total_cost: total_cost,
          cost_breakdown: cost_breakdown
        }
      end)

    selected_grouped_recipe =
      Enum.find(grouped_recipes, fn gr ->
        gr.product.id == target_product_id && Enum.any?(gr.by_media, &(&1.media == media_param))
      end)

    selected_grouped_recipe_with_filtered_media =
      if selected_grouped_recipe do
        %{
          selected_grouped_recipe
          | by_media: Enum.filter(selected_grouped_recipe.by_media, &(&1.media == media_param))
        }
      else
        nil
      end

    socket =
      socket
      |> assign(:page_title, page_title(selected_grouped_recipe_with_filtered_media))
      |> assign(:grouped_recipe, selected_grouped_recipe_with_filtered_media)
      |> assign(:gersang_item_options, gersang_item_options)
      |> assign(:live_action, :show)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"product_id" => product_id, "media" => media_param, "action" => action}, _url, socket) do
    live_action = String.to_atom(action)
    recipes_for_form = Recipes.list_recipes_by_product_and_media(product_id, media_param)

    socket = socket
    |> assign(:live_action, live_action)
    |> assign(:page_title, case live_action do
        :edit -> "Edit Recipe"
        _ -> socket.assigns.page_title
      end)
    |> assign(:gersang_recipes, recipes_for_form)

    {:noreply, socket}
  end

  def handle_params(%{"product_id" => product_id, "media" => media_param}, _url, socket) do
    socket = assign_if_nil(socket, :live_action, :show)
              |> assign_if_nil(:page_title, page_title(socket.assigns.grouped_recipe))

    {:noreply, socket}
  end

  defp assign_if_nil(socket, key, value) do
    if socket.assigns[key], do: socket, else: assign(socket, key, value)
  end

  @impl true
  def handle_event("delete", %{"product_id" => product_id, "media" => media}, socket) do
    product_id_int = if is_binary(product_id), do: String.to_integer(product_id), else: product_id

    import Ecto.Query
    from(r in Recipe, where: r.product_item_id == ^product_id_int and r.media == ^media)
    |> GersangDb.Repo.delete_all()

    {:noreply, push_patch(socket, to: ~p"/gersang/recipes")}
  end

  defp page_title(nil), do: "Recipe not found"
  defp page_title(%{product: product, by_media: [%{media: media} | _]}) do
    "Showing Recipe: #{product.name} from (#{media})"
  end
  defp page_title(_), do: "Recipe Details"

  defp calculate_product_cost(materials) do
    materials_with_prices =
      materials
      |> Enum.filter(&(&1.market_price && &1.market_price > 0))
      |> Enum.map(&{&1.name, &1.market_price})

    case materials_with_prices do
      [] ->
        {0, "0 = 0"}
      prices ->
        total = Enum.reduce(prices, 0, fn {_name, price}, acc -> acc + price end)

        breakdown_parts =
          if Enum.empty?(prices) do
            ["0"]
          else
            Enum.map(prices, fn {_name, price} -> ViewHelpers.format_number_with_commas(price) end)
          end
        breakdown = Enum.join(breakdown_parts, " + ")

        formatted_total = ViewHelpers.format_number_with_commas(total)
        abbreviated = format_abbreviated_number(total)

        total_display = case abbreviated do
          nil -> formatted_total
          abbrev -> "#{formatted_total} (#{abbrev})"
        end
        {total, "#{breakdown} = #{total_display}"}
    end
  end

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

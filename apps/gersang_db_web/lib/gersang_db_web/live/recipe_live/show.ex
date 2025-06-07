defmodule GersangDbWeb.RecipeLive.Show do
  use GersangDbWeb, :live_view

  alias GersangDb.Repo
  alias GersangDbWeb.Utils.ViewHelpers
  alias GersangDb.Gersang.Recipes
  alias GersangDb.GersangItem
  alias GersangDb.Domain.Recipe
  alias GersangDbWeb.RecipeLive.Index, as: RecipeIndex

  @impl true
  def mount(%{"product_id" => product_id, "media" => media_param}, _session, socket) do
    all_recipes = Recipes.list_recipes()
    all_items = GersangItem.list_items()
    gersang_item_options = Enum.map(all_items, fn item -> {item.name, item.id} end)

    product = GersangItem.get_item!(String.to_integer(product_id))

    target_product_id = String.to_integer(product_id)

    grouped_recipes = RecipeIndex.build_grouped_recipe(all_recipes, target_product_id)

    socket =
      socket
      |> assign(:page_title, page_title(grouped_recipes))
      |> assign(:grouped_recipe, grouped_recipes)
      |> assign(:gersang_item_options, gersang_item_options)
      |> assign(:product, product)
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
end

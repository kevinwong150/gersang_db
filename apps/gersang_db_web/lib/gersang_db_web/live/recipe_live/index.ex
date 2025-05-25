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
        by_media =
          product_recipes
          |> Enum.group_by(& &1.media)
          |> Enum.map(fn {media, media_recipes} ->
            material_names =
              media_recipes
              |> Enum.map(& &1.material_item.name)
              |> Enum.uniq()
              |> Enum.sort()
            %{media: media, materials: material_names}
          end)
        %{product: product, by_media: by_media}
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
end

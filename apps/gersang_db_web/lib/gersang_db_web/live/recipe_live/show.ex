defmodule GersangDbWeb.RecipeLive.Show do
  use GersangDbWeb, :live_view

  alias GersangDb.Gersang.Recipes
  alias GersangDb.GersangItem

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"product_id" => product_id, "media" => media}, _, socket) do
    recipe = Recipes.get_recipe_by_product_and_media!(product_id, media)
    full_recipe = GersangDb.Repo.preload(recipe, [:product_item, :material_item])
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:gersang_recipe, full_recipe)
     |> assign(:product_item_options, Enum.map(GersangItem.list_items(), fn item -> {item.name, item.id} end))
     |> assign(:material_item_options, Enum.map(GersangItem.list_items(), fn item -> {item.name, item.id} end))}
  end

  defp page_title(:show), do: "Show Recipe"
  defp page_title(:edit), do: "Edit Recipe"
end

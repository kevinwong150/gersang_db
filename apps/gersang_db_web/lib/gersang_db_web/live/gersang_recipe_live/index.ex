defmodule GersangDbWeb.RecipeLive.Index do
  use GersangDbWeb, :live_view

  alias GersangDb.Gersang.Recipes
  alias GersangDb.Domain.Recipe

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :gersang_recipes, Recipes.list_recipes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Recipe")
    |> assign(:gersang_recipe, Recipes.get_recipe!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe")
    |> assign(:gersang_recipe, %Recipe{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipes")
    |> assign(:gersang_recipe, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    gersang_recipe = Recipes.get_recipe!(id)
    {:ok, _} = Recipes.delete_recipe(gersang_recipe)

    {:noreply, stream_delete(socket, :gersang_recipes, gersang_recipe)}
  end
end

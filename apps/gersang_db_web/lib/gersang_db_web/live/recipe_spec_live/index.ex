defmodule GersangDbWeb.RecipeSpecLive.Index do
  use GersangDbWeb, :live_view
  alias GersangDb.RecipeSpecs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :recipe_specs, RecipeSpecs.list_recipe_specs() |> IO.inspect(label: "Recipe Specs"))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Recipe Spec")
    |> assign(:recipe_spec, RecipeSpecs.get_recipe_spec!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe Spec")
    |> assign(:recipe_spec, %GersangDb.Domain.RecipeSpec{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipe Specs")
    |> assign(:recipe_spec, nil)
  end

  @impl true
  def handle_info({GersangDbWeb.RecipeSpecLive.FormComponent, {:saved, recipe_spec}}, socket) do
    {:noreply, stream_insert(socket, :recipe_specs, recipe_spec)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recipe_spec = RecipeSpecs.get_recipe_spec!(id)
    {:ok, _} = RecipeSpecs.delete_recipe_spec(recipe_spec)

    {:noreply, stream_delete(socket, :recipe_specs, recipe_spec)}
  end
end

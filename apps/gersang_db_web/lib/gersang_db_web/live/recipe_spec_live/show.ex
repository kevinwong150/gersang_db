defmodule GersangDbWeb.RecipeSpecLive.Show do
  use GersangDbWeb, :live_view
  alias GersangDb.RecipeSpecs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:recipe_spec, RecipeSpecs.get_recipe_spec!(id))}
  end

  defp page_title(:show), do: "Show Recipe Spec"
  defp page_title(:edit), do: "Edit Recipe Spec"
end

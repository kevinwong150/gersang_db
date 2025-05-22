defmodule GersangDbWeb.GersangItemLive.Show do
  use GersangDbWeb, :live_view

  alias GersangDb.GersangItem

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:gersang_item, GersangItem.get_item!(id))}
  end

  defp page_title(:show), do: "Show Gersang item"
  defp page_title(:edit), do: "Edit Gersang item"
end

defmodule GersangDbWeb.GersangItemLive.Index do
  use GersangDbWeb, :live_view
  alias GersangDb.GersangItem

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :items, GersangItem.list_items())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Gersang item")
    |> assign(:gersang_item, GersangItem.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Gersang item")
    |> assign(:gersang_item, %GersangDb.Domain.GersangItem{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:gersang_item, nil)
  end

  @impl true
  def handle_info({GersangDbWeb.GersangItemLive.FormComponent, {:saved, gersang_item}}, socket) do
    {:noreply, stream_insert(socket, :items, gersang_item)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do    gersang_item = GersangItem.get_item!(id)
    {:ok, _} = GersangItem.delete_item(gersang_item)

    {:noreply, stream_delete(socket, :items, gersang_item)}
  end
end

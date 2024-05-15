defmodule GersangDbWeb.GersangItemLive.FormComponent do
  use GersangDbWeb, :live_component

  alias GersangDb.GersangItems

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage gersang_item records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="gersang_item-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Gersang item</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{gersang_item: gersang_item} = assigns, socket) do
    changeset = GersangItems.change_item(gersang_item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"gersang_item" => gersang_item_params}, socket) do
    changeset =
      socket.assigns.gersang_item
      |> GersangItems.change_item(gersang_item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"gersang_item" => gersang_item_params}, socket) do
    save_gersang_item(socket, socket.assigns.action, gersang_item_params)
  end

  defp save_gersang_item(socket, :edit, gersang_item_params) do
    case Gersang.update_item(socket.assigns.gersang_item, gersang_item_params) do
      {:ok, gersang_item} ->
        notify_parent({:saved, gersang_item})

        {:noreply,
         socket
         |> put_flash(:info, "Gersang item updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_gersang_item(socket, :new, gersang_item_params) do
    case GersangItems.create_item(gersang_item_params) do
      {:ok, gersang_item} ->
        notify_parent({:saved, gersang_item})

        {:noreply,
         socket
         |> put_flash(:info, "Gersang item created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

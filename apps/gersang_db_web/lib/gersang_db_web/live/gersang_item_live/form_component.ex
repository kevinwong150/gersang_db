defmodule GersangDbWeb.GersangItemLive.FormComponent do
  use GersangDbWeb, :live_component
  alias GersangDb.GersangItem

  @default_tags [
    "Alchemist",
    "Metallurgist",
    "Blacksmith",
    "Loot",
    "Cash Item",
    "Facility",
    "Herbalist",
    "Miner",
    "Crafting"
  ]

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
        <.input field={@form[:name]} type="text" label="Name" />
        <div>
          <.live_component module={GersangDbWeb.GersangItemLive.MultiSelectComponent} id="tags-input" target_handler={@myself} form={@form} field={:tags} label={"Tags"} options={@tags_options} />
        </div>
        <.input field={@form[:margin]} type="number" label="Margin" step="any" />
        <.input field={@form[:market_price]} type="number" label="Market Price" />
        <.input field={@form[:cost_per]} type="number" label="Cost Per" step="any" />
        <.input field={@form[:artisan_product?]} type="checkbox" label="Artisan Product?" />
        <.input field={@form[:artisan_production_amount]} type="number" label="Artisan Production Amount" />
        <.input field={@form[:artisan_production_fee]} type="number" label="Artisan Production Fee" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Gersang item</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{gersang_item: gersang_item} = assigns, socket) do
    changeset = GersangItem.change_item(gersang_item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tags_options, @default_tags)
     |> assign_form(changeset)}
  end
  @impl true
  def handle_event("validate", %{"gersang_item" => gersang_item_params}, socket) do
    processed_params = process_tags(gersang_item_params)

    changeset =
      socket.assigns.gersang_item
      |> GersangItem.change_item(processed_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"gersang_item" => gersang_item_params}, socket) do
    processed_params = process_tags(gersang_item_params)
    save_gersang_item(socket, socket.assigns.action, processed_params)
  end

  defp process_tags(%{"tags" => tags} = params) when is_binary(tags) do
    processed_tags =
      tags
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))

    %{params | "tags" => processed_tags}
  end

  defp process_tags(params), do: params

  defp save_gersang_item(socket, :edit, gersang_item_params) do
    case GersangItem.update_item(socket.assigns.gersang_item, gersang_item_params) do
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
    case GersangItem.create_item(gersang_item_params) do
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

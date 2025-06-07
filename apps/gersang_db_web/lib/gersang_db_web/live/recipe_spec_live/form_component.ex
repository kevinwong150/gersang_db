defmodule GersangDbWeb.RecipeSpecLive.FormComponent do
  use GersangDbWeb, :live_component
  alias GersangDb.RecipeSpecs
  alias GersangDb.GersangItem

  @default_media ["Central Forge", "Weaponary", "Factory", "Armory", "Alchemist", "Metallurgist", "Blacksmith"]

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage recipe spec records in your database.</:subtitle>
      </.header>
      <.simple_form
        for={@form}
        id="recipe_spec-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >        <.input
          field={@form[:product_item_id]}
          type="select"
          label="Product Item"
          options={@gersang_item_options}
          prompt="Select a product item"
        />
        <.input
          field={@form[:media]}
          type="select"
          label="Media"
          options={@default_media}
          prompt="Select a media type"
        />
        <.input field={@form[:production_fee]} type="number" label="Production Fee" />
        <.input field={@form[:production_amount]} type="number" label="Production Amount" />
        <.input field={@form[:wages]} type="number" label="Wages" />
        <.input field={@form[:workload]} type="number" label="Workload" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Recipe Spec</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{recipe_spec: recipe_spec} = assigns, socket) do
    changeset = RecipeSpecs.change_recipe_spec(recipe_spec)
    all_gersang_items = GersangItem.list_items()
    gersang_item_options = Enum.map(all_gersang_items, fn item -> {item.name, item.id} end)
    default_media = @default_media

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:gersang_item_options, gersang_item_options)
      |> assign(:default_media, default_media)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"recipe_spec" => recipe_spec_params}, socket) do
    changeset =
      socket.assigns.recipe_spec
      |> RecipeSpecs.change_recipe_spec(recipe_spec_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"recipe_spec" => recipe_spec_params}, socket) do
    save_recipe_spec(socket, socket.assigns.action, recipe_spec_params)
  end

  defp save_recipe_spec(socket, :edit, recipe_spec_params) do
    case RecipeSpecs.update_recipe_spec(socket.assigns.recipe_spec, recipe_spec_params) do
      {:ok, recipe_spec} ->
        notify_parent({:saved, recipe_spec})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe spec updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_recipe_spec(socket, :new, recipe_spec_params) do
    case RecipeSpecs.create_recipe_spec(recipe_spec_params) do
      {:ok, recipe_spec} ->
        notify_parent({:saved, recipe_spec})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe spec created successfully")
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

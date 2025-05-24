defmodule GersangDbWeb.RecipeLive.FormComponent do
  use GersangDbWeb, :live_component

  alias GersangDb.Gersang.Recipes
  alias GersangDb.Domain.Recipe
  alias GersangDb.GersangItem

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage recipe records in your database.</:subtitle>
      </.header>
      <.simple_form
        for={@form}
        id="recipe-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:media]} type="text" label="Media" />
        <.input field={@form[:product_item_id]} type="select" label="Product Item" options={@product_item_options} required />
        <.input field={@form[:material_item_id]} type="select" label="Material Item" options={@material_item_options} required />
        <:actions>
          <.button phx-disable-with="Saving...">Save Recipe</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{gersang_recipe: gersang_recipe} = assigns, socket) do
    changeset = Recipes.change_recipe(gersang_recipe)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def update(assigns, socket) do
    # Handle the case where :gersang_recipe might not be present (e.g., for :new action initially)
    recipe = assigns.gersang_recipe || %Recipe{}
    changeset = Recipes.change_recipe(recipe)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:gersang_recipe, recipe) # Ensure gersang_recipe is assigned
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      socket.assigns.gersang_recipe
      |> Recipes.change_recipe(recipe_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    save_recipe(socket, socket.assigns.action, recipe_params)
  end

  defp save_recipe(socket, :edit, recipe_params) do
    case Recipes.update_recipe(socket.assigns.gersang_recipe, recipe_params) do
      {:ok, recipe} ->
        notify_parent({:saved, recipe})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_recipe(socket, :new, recipe_params) do
    case Recipes.create_recipe(recipe_params) do
      {:ok, recipe} ->
        notify_parent({:saved, recipe})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
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

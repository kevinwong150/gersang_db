defmodule GersangDbWeb.RecipeLive.FormComponent do
  use GersangDbWeb, :live_component
  alias GersangDb.Gersang.Recipes
  alias GersangDb.GersangItem
  alias GersangDb.Domain.Recipe
  alias GersangDb.Domain.GersangItem, as: GersangItemDomain
  alias GersangDbWeb.InputsComponent

  defmodule EmbeddedRecipe do
    use Ecto.Schema
    import Ecto.Changeset

    alias GersangDb.Domain.GersangItem

    @primary_key false
    embedded_schema do
      field :media, :string
      embeds_one :product_item, GersangItem
      embeds_many :material_items, GersangItem
      field :product_item_id, :integer, virtual: true
      field :material_item_id, :integer, virtual: true
    end

    def changeset(embedded_recipe, attrs) do
      embedded_recipe
      |> cast(attrs, [:media, :product_item_id, :material_item_id])
      |> cast_embed(:product_item, with: &GersangItemDomain.changeset/2, required: true)
      |> cast_embed(:material_items, with: &GersangItemDomain.changeset/2, required: true)
      |> validate_required([:media])
    end
  end

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
        <.input field={@form[:product_item_id]} type="select" label="Product Item" options={@gersang_item_options} required />
        <.live_component
          module={GersangDbWeb.InputsComponent}
          id="material-item-input"
          form={@form}
          field={:material_item_id}
          label="Material Items"
          options={@gersang_item_options}
          required={true}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Recipe</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{gersang_recipe: domain_recipe} = assigns, socket) do
    all_gersang_items = GersangItem.list_items()
    gersang_item_options = Enum.map(all_gersang_items, fn item -> {item.name, item.id} end)

    # IMPORTANT: The :product_item and :material_item associations on domain_recipe
    # should be preloaded before being passed to this component.
    # Example: recipe |> Repo.preload([:product_item, :material_item])

    product_item_attrs =
      if Ecto.assoc_loaded?(domain_recipe.product_item) && domain_recipe.product_item do
        Map.from_struct(domain_recipe.product_item)
      else
        nil
      end

    product_item_id_value =
      if Ecto.assoc_loaded?(domain_recipe.product_item) && domain_recipe.product_item do
        domain_recipe.product_item.id
      else
        nil
      end

    material_items_attrs =
      if Ecto.assoc_loaded?(domain_recipe.material_item) && domain_recipe.material_item do
        [Map.from_struct(domain_recipe.material_item)] # Wrap singular item in a list
      else
        []
      end

    material_item_id_value =
      if Ecto.assoc_loaded?(domain_recipe.material_item) && domain_recipe.material_item do
        domain_recipe.material_item.id
      else
        nil
      end

    initial_embedded_attrs = %{
      "media" => domain_recipe.media,
      "product_item" => product_item_attrs,
      "material_items" => material_items_attrs,
      "product_item_id" => product_item_id_value,
      "material_item_id" => material_item_id_value
    }

    form_changeset = EmbeddedRecipe.changeset(%EmbeddedRecipe{}, initial_embedded_attrs)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:all_gersang_items, all_gersang_items)
     |> assign(:gersang_item_options, gersang_item_options)
     |> assign_form(form_changeset)}
  end

  def update(assigns, socket) do
    all_gersang_items = GersangItem.list_items()
    gersang_item_options = Enum.map(all_gersang_items, fn item -> {item.name, item.id} end)

    form_changeset = EmbeddedRecipe.changeset(%EmbeddedRecipe{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:all_gersang_items, all_gersang_items)
     |> assign(:gersang_item_options, gersang_item_options)
     |> assign_form(form_changeset)}
  end

  @impl true
  def handle_event("validate", %{"embedded_recipe" => embedded_recipe_params}, socket) do
    all_gersang_items = socket.assigns.all_gersang_items
    current_embedded_recipe = socket.assigns.form.data

    product_item_id_str = embedded_recipe_params["product_item_id"]
    material_item_id_str = embedded_recipe_params["material_item_id"]

    product_item_attrs =
      case product_item_id_str do
        nil -> nil
        "" -> nil
        id_str ->
          case Integer.parse(id_str) do
            {parsed_id, _} ->
              found_item = Enum.find(all_gersang_items, &(&1.id == parsed_id))
              if found_item, do: Map.from_struct(found_item), else: nil
            :error ->
              nil
          end
      end

    material_items_attrs_list =
      case material_item_id_str do
        nil -> []
        "" -> []
        id_str ->
          case Integer.parse(id_str) do
            {parsed_id, _} ->
              found_item = Enum.find(all_gersang_items, &(&1.id == parsed_id))
              if found_item, do: [Map.from_struct(found_item)], else: []
            :error ->
              []
          end
      end

    attrs_for_changeset = %{
      "media" => embedded_recipe_params["media"],
      "product_item_id" => product_item_id_str,
      "material_item_id" => material_item_id_str,
      "product_item" => product_item_attrs,
      "material_items" => material_items_attrs_list
    }

    changeset =
      EmbeddedRecipe.changeset(current_embedded_recipe, attrs_for_changeset)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"embedded_recipe" => recipe_params}, socket) do
    {:noreply, socket}
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

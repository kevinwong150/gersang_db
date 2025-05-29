defmodule GersangDbWeb.RecipeLive.FormComponent do
  use GersangDbWeb, :live_component
  alias GersangDb.GersangItem
  alias GersangDb.Domain.GersangItem, as: GersangItemDomain
  import Ecto.Query

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
    end

    def changeset(embedded_recipe, attrs) do
      embedded_recipe
      |> cast(attrs, [:media, :product_item_id])
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

        <.inputs_for :let={material_form} field={@form[:material_items]}>
          <div class="flex items-center gap-2 mb-2">

            <.input field={material_form[:id]} type="select" label={"Material #{material_form.index + 1}"} options={@gersang_item_options} required />

            <.button
              type="button"
              phx-click="remove_material_item"
              phx-target={@myself}
              phx-value-index={material_form.index}
              class="bg-red-500 text-white px-2 py-1 rounded"
            > - </.button>

          </div>
        </.inputs_for>

        <.button
          type="button"
          phx-click="add_material_item"
          phx-target={@myself}
          class="mt-2"
        >
          Add Material Item
        </.button>

        <:actions>
          <.button phx-disable-with="Saving..." disabled={!@form.source.valid?}>Save Recipe</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    all_gersang_items = GersangItem.list_items()
    gersang_item_options = Enum.map(all_gersang_items, fn item -> {item.name, item.id} end)

    initial_changeset_attrs =
      cond do
        (recipes_list = assigns[:gersang_recipes]) && is_list(recipes_list) && !Enum.empty?(recipes_list) ->
          first_recipe = List.first(recipes_list)

          product_item_struct =
            cond do
              (fp_item = first_recipe.product_item) && Ecto.assoc_loaded?(fp_item) ->
                fp_item
              first_recipe.product_item_id ->
                Enum.find(all_gersang_items, &(&1.id == first_recipe.product_item_id))
              true ->
                nil
            end

          product_item_attrs = if product_item_struct, do: Map.from_struct(product_item_struct), else: %{}

          material_items_attrs_list =
            Enum.map(recipes_list, fn recipe ->
              material_item_struct =
                cond do
                  (m_item = recipe.material_item) && Ecto.assoc_loaded?(m_item) ->
                    m_item
                  recipe.material_item_id ->
                    Enum.find(all_gersang_items, &(&1.id == recipe.material_item_id))
                  true ->
                    nil
                end
              if material_item_struct, do: Map.from_struct(material_item_struct), else: nil
            end)
            |> Enum.reject(&is_nil/1)

          %{
            "media" => first_recipe.media,
            "product_item_id" => first_recipe.product_item_id,
            "product_item" => product_item_attrs,
            "material_items" => material_items_attrs_list
          }
        true ->
          %{}
      end

    form_changeset = EmbeddedRecipe.changeset(%EmbeddedRecipe{}, initial_changeset_attrs)

    # Store original values for deletion during save
    original_product_item_id =
      case initial_changeset_attrs do
        %{"product_item_id" => id} when not is_nil(id) -> id
        _ -> nil
      end

    original_media =
      case initial_changeset_attrs do
        %{"media" => media} when not is_nil(media) -> media
        _ -> nil
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:all_gersang_items, all_gersang_items)
     |> assign(:gersang_item_options, gersang_item_options)
     |> assign(:original_product_item_id, original_product_item_id)
     |> assign(:original_media, original_media)
     |> assign_form(form_changeset)}
  end

  @impl true
  def handle_event("validate", %{"embedded_recipe" => embedded_recipe_params}, socket) do
    all_gersang_items = socket.assigns.all_gersang_items
    current_embedded_recipe = socket.assigns.form.data

    product_item_id_str = embedded_recipe_params["product_item_id"]

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

    # Extract material_items params, which is now a map of indexed items
    material_items_params = embedded_recipe_params["material_items"] || %{}

    material_items_attrs_list =
      material_items_params
      |> Map.values() # Get the list of material item params
      |> Enum.map(fn item_params ->
        material_item_id_str = item_params["id"]

        case material_item_id_str do
          nil -> nil # Or handle as an error/empty item
          "" -> nil  # Or handle as an error/empty item
          id_str ->
            case Integer.parse(id_str) do
              {parsed_id, _} ->
                found_item = Enum.find(all_gersang_items, &(&1.id == parsed_id))
                if found_item, do: Map.from_struct(found_item), else: nil
              :error ->
                nil # Or handle parse error
            end
        end
      end)
      |> Enum.reject(&is_nil/1) # Remove any nils if items couldn't be found/parsed

    attrs_for_changeset = %{
      "media" => embedded_recipe_params["media"],
      "product_item_id" => product_item_id_str,
      "product_item" => product_item_attrs,
      "material_items" => material_items_attrs_list
    }

    changeset =
      EmbeddedRecipe.changeset(current_embedded_recipe, attrs_for_changeset)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"embedded_recipe" => recipe_params}, socket) do
    media = recipe_params["media"]
    product_item_id_str = recipe_params["product_item_id"]
    material_items_map = recipe_params["material_items"] || %{}

    product_item_id =
      case Integer.parse(product_item_id_str) do
        {id, ""} -> id
        _ -> nil
      end

    if is_nil(product_item_id) do
      {:noreply, put_flash(socket, :error, "Invalid Product Item ID. Please select a product.") |> assign_form(socket.assigns.form.source)}
    else
      # Build recipe structures for each material item
      recipes_data =
        material_items_map
        |> Map.values()
        |> Enum.map(fn material_param ->
          material_item_id_str = material_param["id"]
          case Integer.parse(material_item_id_str) do
            {mat_id, ""} ->
              %{
                "media" => media,
                "product_item_id" => product_item_id,
                "material_item_id" => mat_id
              }
            _ -> nil
          end
        end)
        |> Enum.reject(&is_nil/1)

      # Start a multi for transactional delete and insert
      multi = Ecto.Multi.new()

      # Delete all existing recipes using the original product_item_id and media
      # This ensures we delete the correct existing recipes even if the user changed the product or media
      original_product_item_id = socket.assigns.original_product_item_id
      original_media = socket.assigns.original_media

      multi =
        if original_product_item_id && original_media do
          Ecto.Multi.delete_all(multi, :delete_existing,
            from(r in GersangDb.Domain.Recipe, where: r.product_item_id == ^original_product_item_id and r.media == ^original_media)
          )
        else
          multi
        end
      # Insert all new recipes
      multi_with_creates =
        Enum.reduce(recipes_data, multi, fn data, acc_multi ->
          changeset = GersangDb.Domain.Recipe.changeset(%GersangDb.Domain.Recipe{}, data)
          item_key = :"create_recipe_#{Ecto.UUID.generate()}"
          Ecto.Multi.insert(acc_multi, item_key, changeset)
        end)

      case GersangDb.Repo.transaction(multi_with_creates) do
        {:ok, results} ->
          created_recipes_list =
            results
            |> Map.values()
            |> Enum.filter(&match?(%GersangDb.Domain.Recipe{}, &1))

          flash_message =
            cond do
              Enum.empty?(created_recipes_list) && Enum.empty?(Map.keys(results)) ->
                "No material items provided to save."
              Enum.empty?(created_recipes_list) ->
                "Could not save recipes due to invalid material item data."
              true ->
                "Recipes saved successfully."
            end

          if not (Enum.empty?(created_recipes_list) && Enum.empty?(Map.keys(results))) do
            notify_parent({:saved, created_recipes_list})
          end

          {:noreply,
           socket
           |> put_flash(:info, flash_message)
           |> push_patch(to: socket.assigns.patch)}

        {:error, failed_op_key, failed_value, _changes_so_far} ->
          error_message =
            if is_struct(failed_value, Ecto.Changeset) do
              "Failed to save recipes. Please check the errors. Operation: #{failed_op_key}."
            else
              "An unexpected error occurred while saving recipes. Operation: #{failed_op_key}."
            end
          {:noreply, assign_form(socket, socket.assigns.form.source) |> put_flash(:error, error_message)}
      end
    end
  end

  def handle_event("remove_material_item", %{"index" => index_str}, socket) do
    index = String.to_integer(index_str)

    form = socket.assigns.form

    existing_material_items = Ecto.Changeset.get_field(form.source, :material_items) || []

    updated_material_items = List.delete_at(existing_material_items, index)

    changeset =
      Ecto.Changeset.put_embed(form.source, :material_items, updated_material_items)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("add_material_item", _, socket) do
    form = socket.assigns.form

    existing_material_items = Ecto.Changeset.get_field(form.source, :material_items) || []

    updated_material_items = existing_material_items ++ [%GersangItemDomain{}]

    changeset =
      Ecto.Changeset.put_embed(form.source, :material_items, updated_material_items)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

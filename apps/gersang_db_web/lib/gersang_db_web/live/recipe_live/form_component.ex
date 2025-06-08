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
      field :recipe_spec_id, :integer
      embeds_one :product_item, GersangItem
      embeds_many :material_items, GersangItem do
        field :material_amount, :integer
        field :material_item_id, :integer, virtual: true
      end
      field :product_item_id, :integer, virtual: true
    end

    def changeset(embedded_recipe, attrs) do
      embedded_recipe
      |> cast(attrs, [:recipe_spec_id, :product_item_id])
      |> cast_embed(:product_item, with: &GersangItemDomain.changeset/2, required: true)
      |> cast_embed(:material_items, with: fn item_struct, params_for_item ->
           Ecto.Changeset.cast(item_struct, params_for_item, [:material_amount, :material_item_id])
           |> Ecto.Changeset.validate_required([:material_amount, :material_item_id])
         end, required: true)
      |> validate_required([:recipe_spec_id])
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
        <.live_component
          module={GersangDbWeb.Component.SearchSelectComponent}
          id="recipe-spec-search"
          form={@form}
          field={:recipe_spec_id}
          label="Recipe Spec"
          options={@recipe_spec_search_options}
          placeholder="Search for recipe spec..."
          target_handler={@myself}
        />

        <.live_component
          module={GersangDbWeb.Component.SearchSelectComponent}
          id="product-item-search"
          form={@form}
          field={:product_item_id}
          label="Product Item"
          options={@gersang_item_options}
          placeholder="Search for product item..."
          target_handler={@myself}
        />

        <.inputs_for :let={material_form} field={@form[:material_items]}>
          <div class="flex items-center gap-2 mb-2">
            <.live_component
              module={GersangDbWeb.Component.SearchSelectComponent}
              id={"material-item-id-search-#{material_form.index}"}
              form={material_form}
              field={:material_item_id}
              label={"Material #{material_form.index + 1}"}
              options={@gersang_item_options}
              placeholder={"Search for mateiral #{material_form.index + 1}..."}
              target_handler={@myself}
            />

            <.input field={material_form[:material_amount]} value={material_form[:material_amount].value || 5} type="number" label="Amount" required />

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

    # Get all recipe specs with product item preloaded
    all_recipe_specs = GersangDb.RecipeSpecs.list_recipe_specs()
    recipe_spec_options = Enum.map(all_recipe_specs, fn recipe_spec ->
      label = "#{recipe_spec.product_item.name} - #{recipe_spec.media}"
      {label, recipe_spec.id}
    end)

    # Prepare search options as {label, value} tuples for the SearchSelectComponent
    recipe_spec_search_options = Enum.map(all_recipe_specs, fn recipe_spec ->
      label = "#{recipe_spec.product_item.name} - #{recipe_spec.media}"
      {label, recipe_spec.id}
    end)

    initial_changeset_attrs =
      cond do
        (recipes_list = assigns[:gersang_recipes]) && is_list(recipes_list) && !Enum.empty?(recipes_list) ->
          first_recipe = List.first(recipes_list)

          # Find the recipe_spec based on product_item_id and media
          recipe_spec = GersangDb.RecipeSpecs.get_recipe_spec_by_product_and_media(
            first_recipe.product_item_id,
            first_recipe.recipe_spec.media
          )

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

              if material_item_struct do
                Map.from_struct(material_item_struct)
                |> Map.put(:material_item_id, recipe.material_item_id)
                |> Map.put(:material_amount, recipe.material_amount)
              else
                nil
              end
            end)
            |> Enum.reject(&is_nil/1)

          %{
            "recipe_spec_id" => recipe_spec && recipe_spec.id,
            "product_item_id" => first_recipe.product_item_id,
            "product_item" => product_item_attrs,
            "material_items" => material_items_attrs_list
          }
        true ->
          %{"material_items" => [%{}]}
      end

    form_changeset = EmbeddedRecipe.changeset(%EmbeddedRecipe{}, initial_changeset_attrs)

    original_product_item_id =
      case initial_changeset_attrs do
        %{"product_item_id" => id} when not is_nil(id) -> id
        _ -> nil
      end

    original_recipe_spec_id =
      case initial_changeset_attrs do
        %{"recipe_spec_id" => id} when not is_nil(id) -> id
        _ -> nil
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:all_gersang_items, all_gersang_items)
     |> assign(:gersang_item_options, gersang_item_options)
     |> assign(:recipe_spec_options, recipe_spec_options)
     |> assign(:recipe_spec_search_options, recipe_spec_search_options)
     |> assign(:original_product_item_id, original_product_item_id)
     |> assign(:original_recipe_spec_id, original_recipe_spec_id)
     |> assign_form(form_changeset)}
  end

  @impl true
  def handle_event("validate", %{"embedded_recipe" => embedded_recipe_params}, socket) do
    all_gersang_items = socket.assigns.all_gersang_items
    current_embedded_recipe = socket.assigns.form.data

    product_item_id = embedded_recipe_params["product_item_id"]

    product_item_attrs =
      case product_item_id do
        id when id in [nil, ""] -> nil
        id when is_binary(id) ->
          case Integer.parse(id) do
            {parsed_id, _} ->
              found_item = Enum.find(all_gersang_items, &(&1.id == parsed_id))
              if found_item, do: Map.from_struct(found_item), else: nil
            :error ->
              nil
          end
        id when is_integer(id) ->
          found_item = Enum.find(all_gersang_items, &(&1.id == id))
          if found_item, do: Map.from_struct(found_item), else: nil
        _ -> nil
      end

    material_items_params = embedded_recipe_params["material_items"] || %{}

    # Handle both map and list formats for material_items_params
    material_items_list =
      case material_items_params do
        map when is_map(map) -> Map.values(map)
        list when is_list(list) -> list
        _ -> []
      end

    material_items_attrs_list =
      material_items_list
      |> Enum.map(fn item_params ->
        material_item_id = item_params["material_item_id"] || item_params[:material_item_id]
        amount = item_params["material_amount"] || item_params[:material_amount]

        item_base_attrs =
          case material_item_id do
            nil -> nil
            "" -> nil
            id when is_binary(id) ->
              case Integer.parse(id) do
                {parsed_id, _} ->
                  found_item = Enum.find(all_gersang_items, &(&1.id == parsed_id))
                  if found_item, do: Map.from_struct(found_item), else: nil
                :error ->
                  nil
              end
            id when is_integer(id) ->
              found_item = Enum.find(all_gersang_items, &(&1.id == id))
              if found_item, do: Map.from_struct(found_item), else: nil
            _ -> nil
          end

        if item_base_attrs do
          item_base_attrs
          |> Map.put(:material_amount, amount)
          |> Map.put(:material_item_id, material_item_id)
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    attrs_for_changeset = %{
      "recipe_spec_id" => embedded_recipe_params["recipe_spec_id"],
      "product_item_id" => product_item_id,
      "product_item" => product_item_attrs,
      "material_items" => material_items_attrs_list
    }
    |> IO.inspect(label: "Attrs for changeset")

    changeset =
      EmbeddedRecipe.changeset(current_embedded_recipe, attrs_for_changeset)
      |> Map.put(:action, :validate)
      |> IO.inspect(label: "Changeset after validation")

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("validate", params, socket) when not is_map_key(params, "embedded_recipe") do
    # Handle individual field validations from SearchSelectComponent
    # Convert params like %{"embedded_recipe[material_items][0]" => %{"material_item_id" => "1"}}
    # to nested format and merge with existing form data for consistency

    # Get current form data to merge with new field updates
    current_form = socket.assigns.form
    current_params = form_to_params(current_form)

    # Convert individual field params to nested format
    nested_field_params =
      params
      |> Enum.reduce(%{}, fn {key, value}, acc ->
        case parse_nested_key(key) do
          {:ok, nested_structure} ->
            put_in_nested(acc, nested_structure, value)
          :error ->
            acc
        end
      end)

    # Deep merge the new field params with existing form data
    merged_params = deep_merge(current_params, nested_field_params)
    |> IO.inspect(label: "Merged Params")

    # Call the main validation handler with the merged params
    handle_event("validate", merged_params, socket)
  end

  @impl true
  def handle_event("save", %{"embedded_recipe" => recipe_params}, socket) do
    recipe_spec_id = recipe_params["recipe_spec_id"]
    product_item_id = recipe_params["product_item_id"]
    material_items_map = recipe_params["material_items"] || %{}

    if is_nil(recipe_spec_id) do
      {:noreply, put_flash(socket, :error, "Invalid Recipe Spec ID. Please select a recipe spec.") |> assign_form(socket.assigns.form.source)}
    else
      # Get the recipe_spec to find the media and product_item_id
      recipe_spec = GersangDb.RecipeSpecs.get_recipe_spec!(recipe_spec_id)
      media = recipe_spec.media
      product_item_id = recipe_spec.product_item_id

      recipes_data =
        material_items_map
        |> Map.values()
        |> Enum.map(fn material_param ->
          material_item_id = material_param["material_item_id"] || material_param[:material_item_id]
          amount = material_param["material_amount"] || material_param[:material_amount]

          %{
            "recipe_spec_id" => recipe_spec_id,
            "product_item_id" => product_item_id,
            "material_item_id" => material_item_id,
            "material_amount" => amount
          }
        end)
        |> Enum.reject(&is_nil/1)

      multi = Ecto.Multi.new()

      original_product_item_id = socket.assigns.original_product_item_id
      original_recipe_spec_id = socket.assigns.original_recipe_spec_id

      multi =
        if original_recipe_spec_id do
          # Get the original recipe_spec to find the original media
          original_recipe_spec = GersangDb.RecipeSpecs.get_recipe_spec!(original_recipe_spec_id)
          original_product_item_id = original_recipe_spec.product_item_id

          Ecto.Multi.delete_all(multi, :delete_existing,
            from(r in GersangDb.Domain.Recipe, where: r.product_item_id == ^original_product_item_id and r.recipe_spec_id == ^original_recipe_spec.id)
          )
        else
          multi
        end

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

    updated_material_items = existing_material_items ++ [%{material_amount: 5}]

    changeset =
      Ecto.Changeset.put_embed(form.source, :material_items, updated_material_items)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  # Helper function to parse nested form field names like "embedded_recipe[material_items][0]"
  defp parse_nested_key(key) do
    case String.split(key, ~r/\[|\]/, trim: true) do
      [base | indices] when base in ["embedded_recipe"] ->
        {:ok, [base | indices]}
      _ ->
        :error
    end
  end

  # Helper function to put a value in a nested structure
  defp put_in_nested(map, [], value), do: value
  defp put_in_nested(map, [key], value) do
    Map.put(map, key, value)
  end
  defp put_in_nested(map, [key | rest], value) do
    current = Map.get(map, key, %{})
    Map.put(map, key, put_in_nested(current, rest, value))
  end

  # Helper function to convert form data back to params format for merging
  defp form_to_params(form) do
    changeset = form.source

    # Extract current data from the changeset
    recipe_spec_id = Ecto.Changeset.get_field(changeset, :recipe_spec_id)
    product_item_id = Ecto.Changeset.get_field(changeset, :product_item_id)
    product_item = Ecto.Changeset.get_field(changeset, :product_item)
    material_items = Ecto.Changeset.get_field(changeset, :material_items) || []

    # Convert product_item struct to params if present
    product_item_params =
      if product_item && is_struct(product_item) do
        Map.from_struct(product_item)
        |> Map.drop([:__meta__, :__struct__])
      else
        product_item
      end

    # Convert material_items to indexed map format
    material_items_params =
      material_items
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {item, index}, acc ->
        item_params =
          if is_struct(item) do
            Map.from_struct(item)
            |> Map.drop([:__meta__, :__struct__])
          else
            item || %{}
          end
        Map.put(acc, to_string(index), item_params)
      end)

    %{
      "embedded_recipe" => %{
        "recipe_spec_id" => recipe_spec_id,
        "product_item_id" => product_item_id,
        "product_item" => product_item_params,
        "material_items" => material_items_params
      }
    }
  end

  # Helper function to deep merge two maps
  defp deep_merge(left, right) do
    Map.merge(left, right, fn _key, left_val, right_val ->
      case {left_val, right_val} do
        {left_map, right_map} when is_map(left_map) and is_map(right_map) ->
          deep_merge(left_map, right_map)
        {_left, right} ->
          right
      end
    end)
  end

  # Helper functions for options handling
end

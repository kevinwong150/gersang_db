defmodule GersangDbWeb.RecipeLive.RecipesCostCalculator do
  use GersangDbWeb, :live_component

  alias GersangDb.Repo
  alias GersangDbWeb.Router.Helpers, as: Routes
  alias GersangDb.Recipes
  alias GersangDb.GersangItem
  alias GersangDbWeb.Utils.ViewHelpers

  @impl true
  def update(assigns, socket) do
    product = assigns[:product]

    materials_tree =
      case product do
        nil ->
          %{}
        %GersangDb.Domain.GersangItem{} ->
          GersangDb.GersangItem.preload_material(product)
          |> build_materials_tree()
      end

    socket =
      socket
      |> assign(assigns)
      |> assign(:materials_tree, materials_tree)
      |> assign_new(:calculated_cost, fn -> nil end)
      |> assign_new(:highlighted_item_id, fn -> nil end) # Initialize highlighted_item_id
      |> assign_new(:related_item_ids, fn -> %{} end)    # Initialize related_item_ids
      |> assign_new(:ingredient_costs, fn -> initialize_ingredient_costs(materials_tree) end)
      |> assign_new(:expanded_nodes, fn -> initialize_expanded_nodes(materials_tree) end)

    {:ok, socket}
  end

  @impl true
  def handle_event("calculate", %{"ingredient_costs" => ingredient_costs}, socket) do
    # In a real scenario, you'd parse ingredient_costs,
    # fetch prices, calculate total, etc.
    # For now, let's just simulate a calculation.
    calculated_cost =
      Enum.reduce(ingredient_costs, 0, fn {_item_id, cost_str}, acc ->
        case Integer.parse(cost_str) do
          {cost, ""} -> acc + cost
          _error -> acc # Ignore invalid inputs for now
        end
      end)

    {:noreply, assign(socket, :calculated_cost, calculated_cost)}
  end

  # Add other handle_event functions as needed, for example, to update individual ingredient costs
  def handle_event("update_ingredient_cost", %{"item-id" => item_id, "value" => cost}, socket) do
    # Logic to update a specific ingredient's cost in the form
    # This would likely involve updating assigns that are used to render the form fields

    # Parse the cost and update the ingredient_costs map, ensuring integers only
    parsed_cost = case cost do
      "" -> 0
      nil -> 0
      cost_str when is_binary(cost_str) ->
        case Integer.parse(cost_str) do
          {parsed, ""} -> parsed
          {parsed, _} -> parsed
          :error ->
            # Fallback to float parsing then convert to integer
            case Float.parse(cost_str) do
              {parsed, _} -> trunc(parsed)
              :error -> 0
            end
        end
      cost_num when is_number(cost_num) -> trunc(cost_num)
      _ -> 0
    end

    updated_ingredient_costs = Map.put(socket.assigns.ingredient_costs, String.to_integer(item_id), parsed_cost)

    socket = assign(socket, :ingredient_costs, updated_ingredient_costs)
    {:noreply, socket}
  end

  def handle_event("highlight_material", %{"item-id" => item_id}, socket) do
    # Highlight the material and related items
    item_id_int = String.to_integer(item_id)

    socket =
      socket
      |> assign(:highlighted_item_id, item_id_int)
      |> assign(:related_item_ids, %{item_id_int => [item_id_int]})

    {:noreply, socket}
  end

  def handle_event("toggle_node", %{"item-id" => item_id}, socket) do
    item_id_int = String.to_integer(item_id)
    expanded_nodes = socket.assigns.expanded_nodes

    updated_expanded_nodes =
      if Map.get(expanded_nodes, item_id_int, true) do
        Map.put(expanded_nodes, item_id_int, false)
      else
        Map.put(expanded_nodes, item_id_int, true)
      end

    {:noreply, assign(socket, :expanded_nodes, updated_expanded_nodes)}
  end

  def handle_event("expand_all", %{"item-id" => item_id}, socket) do
    item_id_int = String.to_integer(item_id)
    expanded_nodes = socket.assigns.expanded_nodes

    # Get all descendant node IDs for this item
    descendant_ids = get_all_descendant_ids(item_id_int, socket.assigns.materials_tree)

    # Set all descendants to expanded
    updated_expanded_nodes =
      Enum.reduce([item_id_int | descendant_ids], expanded_nodes, fn id, acc ->
        Map.put(acc, id, true)
      end)

    {:noreply, assign(socket, :expanded_nodes, updated_expanded_nodes)}
  end
  def handle_event("collapse_all", %{"item-id" => item_id}, socket) do
    item_id_int = String.to_integer(item_id)
    expanded_nodes = socket.assigns.expanded_nodes

    # Get all descendant node IDs for this item
    descendant_ids = get_all_descendant_ids(item_id_int, socket.assigns.materials_tree)

    # Set all descendants to collapsed
    updated_expanded_nodes =
      Enum.reduce(descendant_ids, expanded_nodes, fn id, acc ->
        Map.put(acc, id, false)
      end)

    {:noreply, assign(socket, :expanded_nodes, updated_expanded_nodes)}
  end

  def handle_event("update_cost", %{"item-id" => item_id}, socket) do
    item_id_int = String.to_integer(item_id)

    # Calculate the total cost for this item
    total_cost = calculate_materials_cost(item_id_int, socket.assigns.materials_tree, socket.assigns.ingredient_costs)

    # Get the item to access its market price
    item_node = get_item_from_nodes(item_id_int, socket.assigns.materials_tree)

    if item_node do
      item = item_node.item
      market_price = item.market_price || 0

      # Calculate margin as percentage: ((market_price - cost_per) / cost_per) * 100
      margin = if total_cost > 0 do
        ((market_price - total_cost) / total_cost) * 100
      else
        0.0
      end

      # Update the item with calculated cost and margin
      case GersangDb.GersangItem.update_item(item, %{
        cost_per: total_cost,
        margin: margin
      }) do
        {:ok, updated_item} ->
          # Update the materials tree with the updated item
          updated_materials_tree = update_item_in_materials_tree(socket.assigns.materials_tree, updated_item)

          socket =
            socket
            |> assign(:materials_tree, updated_materials_tree)
            |> put_flash(:info, "Cost updated successfully! Total cost: #{ViewHelpers.format_number_with_commas(total_cost)}, Margin: #{Float.round(margin, 2)}%")

          {:noreply, socket}

        {:error, _changeset} ->
          socket = put_flash(socket, :error, "Failed to update cost")
          {:noreply, socket}
      end
    else
      socket = put_flash(socket, :error, "Item not found")
      {:noreply, socket}
    end
  end

  def build_materials_tree(%GersangDb.Domain.GersangItem{} = product) do
    layer = 0
    tree = %{"#{layer}" => [%{
      item: product,
      production_fee: get_item_production_fee(product),
      production_amount: get_item_production_amount(product),
      parent_id: nil
    }]}

    next_layer_materials_with_parents =
      product.materials
      |> Enum.map(fn material ->
        %{
          item: material,
          amount: get_material_amount_from_recipe(product, material),
          production_fee: get_item_production_fee(material),
          production_amount: get_item_production_amount(material),
          parent_id: product.id
        }
      end)

    build_materials_tree(next_layer_materials_with_parents, layer + 1, tree)
  end

  defp build_materials_tree([], _layer, tree) do
    tree
  end

  defp build_materials_tree(materials_with_parents, layer, tree) when is_list(materials_with_parents) and is_map(tree) do
    base_tree = Map.put(tree, "#{layer}", materials_with_parents)

    next_layer_materials_with_parents = list_next_layer_materials_with_parent(materials_with_parents)

    build_materials_tree(next_layer_materials_with_parents, layer + 1, base_tree)
  end

  defp build_materials_tree(_, _layer, tree) do
    tree
  end

  def list_next_layer_materials_with_parent(materials_with_parents) do
    materials_with_parents
    |> Enum.flat_map(fn %{item: item} ->
      item.materials
      |> Enum.map(fn material ->
        %{
          item: material,
          amount: get_material_amount_from_recipe(item, material),
          production_fee: get_item_production_fee(material),
          production_amount: get_item_production_amount(material),
          parent_id: item.id
        }
      end)
    end)
  end

  def get_item_production_fee(%GersangDb.Domain.GersangItem{} = item) do
    item
    |> Map.get(:recipes_as_product, [])
    |> Enum.map(& &1.recipe_spec.production_fee)
    |> Enum.max(fn -> 0 end) # Return the maximum production fee from all recipes, or 0 if none
  end

  def get_item_production_amount(%GersangDb.Domain.GersangItem{} = item) do
    item
    |> Map.get(:recipes_as_product, [])
    |> Enum.map(& &1.recipe_spec.production_amount)
    |> Enum.max(fn -> 1 end) # Return the maximum production amount from all recipes, or 1 if none
  end

  def get_material_amount_from_recipe(%GersangDb.Domain.GersangItem{} = product, %GersangDb.Domain.GersangItem{} = material) do
    product
    |> Map.get(:recipes_as_product, [])
    |> Enum.find(fn recipe ->
      recipe.material_item_id == material.id
    end)
    |> then(fn
      nil -> 1 # Default amount if no recipe found
      recipe -> recipe.material_amount || 1 # Use the recipe's amount or default to 1
    end)
  end

  # Function component for rendering a tree node
  attr :node, :map, required: true
  attr :layer_index, :integer, required: true
  attr :all_nodes, :map, required: true
  attr :highlighted_item_id, :any, default: nil
  attr :related_item_ids, :map, default: %{}
  attr :ingredient_costs, :map, default: %{}
  attr :expanded_nodes, :map, default: %{}
  attr :target_handler, :any, required: true
  def material_tree_node(assigns) do
    children = find_children(assigns.node.item.id, assigns.layer_index + 1, assigns.all_nodes)
    has_children = !Enum.empty?(children)
    is_expanded = Map.get(assigns.expanded_nodes, assigns.node.item.id, true)

    assigns = assign(assigns, :children, children)
    assigns = assign(assigns, :has_children, has_children)
    assigns = assign(assigns, :is_expanded, is_expanded)

    ~H"""
    <div
      class={[
        "material-node p-4 my-3 rounded-xl shadow-md transition-all duration-300 hover:shadow-lg transform hover:-translate-y-0.5",
        get_highlight_class(assigns.node.item.id, assigns.highlighted_item_id, assigns.related_item_ids),
        get_layer_styling(@layer_index)
      ]}
      style={"margin-left: #{@layer_index * 24}px;"}
      phx-value-item-id={@node.item.id}
      id={"item-" <> Integer.to_string(@node.item.id)}
    >
      <div class="mb-4">
        <div class="flex justify-between items-center mb-3">
          <div class="flex items-center gap-3">
            <%= if @has_children do %>
              <!-- Toggle Button -->
              <button
                type="button"
                phx-click="toggle_node"
                phx-value-item-id={@node.item.id}
                phx-target={@target_handler}
                class="flex items-center justify-center w-8 h-8 rounded-full bg-white border-2 border-gray-400 hover:border-indigo-500 hover:bg-indigo-50 transition-all duration-200 shadow-sm cursor-pointer"
                title={if @is_expanded, do: "Collapse", else: "Expand"}
              >
                <svg class="w-4 h-4 text-gray-700 hover:text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <%= if @is_expanded do %>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 9l-7 7-7-7" />
                  <% else %>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7" />
                  <% end %>
                </svg>
              </button>
            <% else %>
              <!-- Spacer with decorative icon for leaf nodes -->
              <div class="w-8 h-8 flex items-center justify-center rounded-full bg-slate-100 border border-slate-300">
                <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
            <% end %>

            <div class="flex flex-col">
              <div class="flex items-center gap-2">
                <div class="flex items-center gap-2">
                  <span class={get_item_name_styling(@layer_index, @has_children)}><%= @node.item.name %></span>
                  <%= if Map.has_key?(@node, :amount) && @node.amount && @node.amount > 1 do %>
                    <span class="px-2 py-1 text-xs font-bold bg-indigo-100 text-indigo-800 rounded-full border border-indigo-300 shadow-sm">
                      × <%= @node.amount %>
                    </span>
                  <% end %>
                  <!-- Production Amount Display -->
                  <%= if @node.production_amount && @node.production_amount > 1 do %>
                    <span class="px-2 py-1 text-xs font-bold bg-green-100 text-green-800 rounded-full border border-green-300 shadow-sm" title="Production Amount">
                      📦 <%= @node.production_amount %>
                    </span>
                  <% end %>
                  <!-- Margin Display - Only for root product (layer 0) -->
                  <%= if @layer_index == 0 && @node.item.margin do %>
                    <span class={[
                      "px-2 py-1 text-xs font-bold rounded-full border shadow-sm",
                      if @node.item.margin >= 0 do
                        "bg-emerald-100 text-emerald-800 border-emerald-300"
                      else
                        "bg-red-100 text-red-800 border-red-300"
                      end
                    ]} title="Profit Margin">
                      <%= if @node.item.margin >= 0, do: "📈", else: "📉" %> <%= Float.round(@node.item.margin, 2) %>%
                    </span>
                  <% end %>
                </div>

                <%= if @has_children do %>
                  <!-- Total Cost Display - Prominent -->
                  <div class="ml-auto px-3 py-1.5 bg-gradient-to-r from-emerald-100 to-green-100 border-2 border-emerald-300 rounded-lg shadow-sm">
                    <span class="text-sm font-bold text-emerald-800">
                      💰 <%=
                        total_cost = calculate_materials_cost(@node.item.id, @all_nodes, @ingredient_costs)
                        formatted_total = ViewHelpers.format_number_with_commas(total_cost)
                        abbreviated = format_abbreviated_number(total_cost)
                        case abbreviated do
                          nil -> formatted_total
                          abbrev -> "#{formatted_total} (#{abbrev})"
                        end
                      %>
                    </span>
                  </div>
                <% end %>
              </div>

              <span class="text-xs text-slate-500 font-medium"># <%= @node.item.id %></span>              <!-- Production Information Section -->
              <%= if @node.production_fee && @node.production_fee > 0 || @node.production_amount && @node.production_amount > 1 || (@layer_index == 0 && @node.item.cost_per) do %>
                <div class="mt-2 flex gap-3 text-xs">
                  <%= if @node.production_fee && @node.production_fee > 0 do %>
                    <div class="flex items-center gap-1 px-2 py-1 bg-orange-50 border border-orange-200 rounded-md">
                      <span class="text-orange-600 font-medium">🔧 Production Fee:</span>
                      <span class="text-orange-800 font-bold"><%= ViewHelpers.format_number_with_commas(@node.production_fee) %></span>
                    </div>
                  <% end %>
                  <%= if @node.production_amount && @node.production_amount > 1 do %>
                    <div class="flex items-center gap-1 px-2 py-1 bg-green-50 border border-green-200 rounded-md">
                      <span class="text-green-600 font-medium">📦 Produces:</span>
                      <span class="text-green-800 font-bold"><%= @node.production_amount %> items</span>
                    </div>
                  <% end %>
                  <!-- Saved Cost Per Display - Only for root product (layer 0) -->
                  <%= if @layer_index == 0 && @node.item.cost_per do %>
                    <div class="flex items-center gap-1 px-2 py-1 bg-blue-50 border border-blue-200 rounded-md">
                      <span class="text-blue-600 font-medium">💾 Saved Cost:</span>
                      <span class="text-blue-800 font-bold"><%= ViewHelpers.format_number_with_commas(@node.item.cost_per) %></span>
                    </div>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>          <%= if @has_children do %>
            <!-- Expand All / Collapse All Buttons -->
            <div class="flex gap-2">
              <button
                type="button"
                phx-click="expand_all"
                phx-value-item-id={@node.item.id}
                phx-target={@target_handler}
                class="px-3 py-1.5 text-xs bg-emerald-100 hover:bg-emerald-200 text-emerald-800 rounded-lg border border-emerald-300 transition-colors font-medium shadow-sm cursor-pointer"
                title="Expand All"
              >
                ↓ Expand All
              </button>
              <button
                type="button"
                phx-click="collapse_all"
                phx-value-item-id={@node.item.id}
                phx-target={@target_handler}
                class="px-3 py-1.5 text-xs bg-rose-100 hover:bg-rose-200 text-rose-800 rounded-lg border border-rose-300 transition-colors font-medium shadow-sm cursor-pointer"
                title="Collapse All"
              >
                ↑ Collapse All
              </button>

              <!-- Update Cost Button - Only for root product (layer 0) -->
              <%= if @layer_index == 0 do %>
                <button
                  type="button"
                  phx-click="update_cost"
                  phx-value-item-id={@node.item.id}
                  phx-target={@target_handler}
                  class="px-3 py-1.5 text-xs bg-blue-100 hover:bg-blue-200 text-blue-800 rounded-lg border border-blue-300 transition-colors font-medium shadow-sm cursor-pointer"
                  title="Save calculated cost to database and update margin"
                >
                  💾 Update Cost
                </button>
              <% end %>
            </div>
          <% end %>
        </div>

        <div class="flex gap-4 items-end">
          <!-- Cost Breakdown Display (for items with materials) - First -->
          <%= if @has_children do %>
            <div class="flex flex-col flex-1">
              <label class="text-sm font-semibold text-amber-700 mb-2">📊 Cost Breakdown</label>
              <div class="bg-gradient-to-r from-amber-50 to-yellow-50 border-2 border-amber-200 rounded-xl p-4 shadow-sm">
                <div class="flex flex-col">
                  <.cost_breakdown_formula
                    parent_item_id={@node.item.id}
                    all_nodes={@all_nodes}
                    ingredient_costs={@ingredient_costs}
                    target_handler={@target_handler}
                  />
                </div>
              </div>
            </div>
          <% end %>

          <!-- Cost Input (Editable) - Second, hide for root product (layer 0) -->
          <%= if @layer_index > 0 do %>
            <div class="flex flex-col flex-1">
              <label class="text-sm font-semibold text-blue-700 mb-2">✏️ Cost</label>
              <input
                type="number"
                step="10000"
                value={Map.get(@ingredient_costs, @node.item.id, @node.item.market_price || 0)}
                phx-blur="update_ingredient_cost"
                phx-value-item-id={@node.item.id}
                phx-target={@target_handler}
                name={"ingredient_costs[#{@node.item.id}]"}
                class="px-3 py-2 text-sm border-2 border-blue-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 focus:outline-none transition-all duration-200 bg-blue-50 cursor-text"
                placeholder="Enter cost"
              />
            </div>
          <% end %>

          <!-- Market Price Input (Disabled) - Third -->
          <div class="flex flex-col flex-1">
            <label class="text-sm font-semibold text-gray-600 mb-2">🏪 Market Price</label>
            <input
              type="number"
              disabled
              value={trunc(@node.item.market_price || 0)}
              class="px-3 py-2 text-sm bg-gradient-to-r from-gray-100 to-gray-200 border-2 border-gray-300 rounded-lg text-gray-700 cursor-not-allowed"
              placeholder="N/A"
            />
          </div>
        </div>
      </div>

      <!-- Children nodes - only show if expanded -->
      <%= if @has_children and @is_expanded do %>
        <div class="children-nodes mt-1 pl-3 border-l border-gray-300">
          <%= for child_node <- @children do %>
            <.material_tree_node
              target_handler={@target_handler}
              node={child_node}
              layer_index={@layer_index + 1}
              all_nodes={@all_nodes}
              highlighted_item_id={@highlighted_item_id}
              related_item_ids={@related_item_ids}
              ingredient_costs={@ingredient_costs}
              expanded_nodes={@expanded_nodes}
            />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  # Function component for rendering interactive cost breakdown with production costs
  attr :parent_item_id, :integer, required: true
  attr :all_nodes, :map, required: true
  attr :ingredient_costs, :map, default: %{}
  attr :target_handler, :any, required: true
  def cost_breakdown_formula(assigns) do
    breakdown_data = calculate_materials_cost_breakdown(assigns.parent_item_id, assigns.all_nodes, assigns.ingredient_costs)
    assigns = assign(assigns, :breakdown_data, breakdown_data)

    ~H"""
    <div class="text-yellow-800 font-mono text-xs space-y-2">
      <%= case @breakdown_data do %>
        <% {_total, _equation, [], _production_fee, _production_amount} -> %>
          <span>No materials available</span>

        <% {total, equation, materials, production_fee, production_amount} when length(materials) > 0 -> %>
          <!-- Interactive materials breakdown -->
          <div class="flex flex-wrap items-center gap-1">
            <span class="text-yellow-700 font-medium">(</span>
            <%= for {material, index} <- Enum.with_index(materials) do %>
              <%= if index > 0 do %>
                <span class="text-yellow-600"> + </span>
              <% end %>
              <span
                class="hover:bg-yellow-200 hover:text-yellow-900 px-1 rounded cursor-pointer transition-colors relative group"
                phx-click="highlight_material"
                phx-value-item-id={material.item_id}
                phx-target={@target_handler}
                title={material.name}
              >
                <%= ViewHelpers.format_number_with_commas(material.total_price) %>
                <div class="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 px-2 py-1 bg-gray-800 text-white text-xs rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10 pointer-events-none">
                  <%= material.name %><%= if Map.has_key?(material, :amount) && material.amount > 1, do: " × #{material.amount}", else: "" %>
                </div>
              </span>
            <% end %>

            <%= if production_fee > 0 do %>
              <span class="text-yellow-600"> + </span>
              <span class="text-orange-700 font-medium hover:bg-yellow-200 hover:text-yellow-900 px-1 rounded cursor-pointer transition-colors relative group" title="Production Fee">
                <%= ViewHelpers.format_number_with_commas(production_fee) %>
                <div class="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 px-2 py-1 bg-gray-800 text-white text-xs rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap z-10 pointer-events-none">
                  Production Fee
                </div>
              </span>
            <% end %>

            <span class="text-yellow-700 font-medium">)</span>

            <%= if production_amount > 1 do %>
              <span class="text-yellow-600"> ÷ </span>
              <span class="text-green-700 font-medium" title="Production Amount">
                <%= production_amount %>
              </span>
            <% end %>

            <span class="text-yellow-600"> = </span>
            <span class="text-emerald-800 font-bold">
              <%= ViewHelpers.format_number_with_commas(total) %>
            </span>
          </div>

        <% _ -> %>
          <span>No prices available</span>
      <% end %>
    </div>
    """
  end

  # Helper function to get an item from all nodes by item_id
  defp get_item_from_nodes(item_id, all_nodes) do
    all_nodes
    |> Enum.flat_map(fn {_layer, nodes} -> nodes end)
    |> Enum.find(fn %{item: item} -> item.id == item_id end)
  end

  defp calculate_materials_cost(item_id, all_nodes, ingredient_costs) do
    # Find all direct materials (children) of this item
    children = find_children(item_id, get_item_layer(item_id, all_nodes) + 1, all_nodes)

    if Enum.empty?(children) do
      0  # No materials, so cost is 0
    else
      # Calculate materials cost
      materials_total = children
      |> Enum.reduce(0, fn %{item: child_item, amount: amount}, acc ->
        # Check if this child has its own materials (is a parent item)
        child_has_materials = !Enum.empty?(find_children(child_item.id, get_item_layer(child_item.id, all_nodes) + 1, all_nodes))

        child_cost = if child_has_materials do
          # If child has materials, use its calculated cost (recursive)
          calculate_materials_cost(child_item.id, all_nodes, ingredient_costs)
        else
          # If child has no materials, use its input cost
          Map.get(ingredient_costs, child_item.id, 0)
        end

        # Multiply by the amount needed
        total_cost = child_cost * (amount || 1)
        acc + total_cost
      end)

      # Get the current item to access its production info
      current_item = get_item_from_nodes(item_id, all_nodes)
      production_fee = (current_item && current_item[:production_fee]) || 0
      production_amount = (current_item && current_item[:production_amount]) || 1

      # Apply the formula: (materials_total + production_fee) / production_amount
      total_before_division = materials_total + production_fee
      total_before_division / production_amount
    end
  end

  defp calculate_materials_cost_breakdown(item_id, all_nodes, ingredient_costs) do
    # Find all direct materials (children) of this item
    children = find_children(item_id, get_item_layer(item_id, all_nodes) + 1, all_nodes)

    # Get the current item to access its production info
    current_item = get_item_from_nodes(item_id, all_nodes)
    production_fee = (current_item && current_item[:production_fee]) || 0
    production_amount = (current_item && current_item[:production_amount]) || 1

    if Enum.empty?(children) do
      # If only production fee exists
      if production_fee > 0 do
        total = production_fee / production_amount
        formatted_total = ViewHelpers.format_number_with_commas(total)

        equation = if production_amount > 1 do
          "#{ViewHelpers.format_number_with_commas(production_fee)} ÷ #{production_amount} = #{formatted_total}"
        else
          "#{ViewHelpers.format_number_with_commas(production_fee)} = #{formatted_total}"
        end

        {total, equation, [], production_fee, production_amount}
      else
        {0, "No materials or production costs available", [], 0, 1}
      end
    else
      materials_for_costing =
        children
        |> Enum.map(fn %{item: child_item, amount: amount} ->
          # Check if this child has its own materials (is a parent item)
          child_has_materials = !Enum.empty?(find_children(child_item.id, get_item_layer(child_item.id, all_nodes) + 1, all_nodes))

          child_cost = if child_has_materials do
            # If child has materials, use its calculated cost (recursive)
            calculate_materials_cost(child_item.id, all_nodes, ingredient_costs)
          else
            # If child has no materials, use its input cost
            Map.get(ingredient_costs, child_item.id, 0)
          end

          # Multiply by the amount needed
          total_cost = child_cost * (amount || 1)

          %{name: child_item.name, total_price: total_cost, item_id: child_item.id, amount: amount || 1}
        end)
        |> Enum.filter(fn %{total_price: price} -> price > 0 end)
        # Group by item_id and sum up the total_price and amount for duplicates
        |> Enum.group_by(fn %{item_id: item_id} -> item_id end)
        |> Enum.map(fn {_item_id, materials} ->
          # Sum up amounts and total_price for the same item
          total_amount = Enum.reduce(materials, 0, fn %{amount: amount}, acc -> acc + amount end)
          total_price = Enum.reduce(materials, 0, fn %{total_price: price}, acc -> acc + price end)

          # Take the name from the first material (they should all be the same)
          %{name: name, item_id: item_id} = List.first(materials)

          %{name: name, total_price: total_price, item_id: item_id, amount: total_amount}
        end)

      case materials_for_costing do
        [] when production_fee == 0 ->
          {0, "No prices available", [], 0, 1}
        [] ->
          # Only production fee
          total = production_fee / production_amount
          formatted_total = ViewHelpers.format_number_with_commas(total)

          equation = if production_amount > 1 do
            "#{ViewHelpers.format_number_with_commas(production_fee)} ÷ #{production_amount} = #{formatted_total}"
          else
            "#{ViewHelpers.format_number_with_commas(production_fee)} = #{formatted_total}"
          end

          {total, equation, [], production_fee, production_amount}
        priced_materials ->
          materials_total = Enum.reduce(priced_materials, 0, fn material, acc -> acc + material.total_price end)
          total_before_division = materials_total + production_fee
          total = total_before_division / production_amount

          # Build the equation string
          materials_breakdown =
            priced_materials
            |> Enum.map(fn material -> ViewHelpers.format_number_with_commas(material.total_price) end)
            |> Enum.join(" + ")

          breakdown_before_division = if production_fee > 0 do
            production_fee_part = ViewHelpers.format_number_with_commas(production_fee)
            "(#{materials_breakdown} + #{production_fee_part})"
          else
            "(#{materials_breakdown})"
          end

          formatted_total = ViewHelpers.format_number_with_commas(total)

          equation = "#{breakdown_before_division} / #{production_amount} = #{formatted_total}"

          {total, equation, priced_materials, production_fee, production_amount}
      end
    end
  end

  defp find_children(parent_id, child_layer_index, all_nodes) do
    child_layer_key = Integer.to_string(child_layer_index)
    case Map.get(all_nodes, child_layer_key) do
      nil -> []
      nodes -> Enum.filter(nodes, &(&1.parent_id == parent_id))
    end
  end

  defp get_highlight_class(current_node_id, highlighted_item_id, related_ids_map) do
    cond do
      current_node_id == highlighted_item_id ->
        "bg-blue-100 border-blue-500 shadow-lg ring-2 ring-blue-200" # Highlight for the item itself (mouseover target)

      # Check if highlighted_item_id exists and has related items
      highlighted_item_id && Map.has_key?(related_ids_map, highlighted_item_id) ->
        related_ids = related_ids_map[highlighted_item_id] # Fetch the list of related IDs

        if is_list(related_ids) && Enum.member?(related_ids, current_node_id) do
          "bg-green-50 border-green-400 shadow-md ring-1 ring-green-200" # Highlight for related items
        else
          "bg-gradient-to-r from-slate-50 to-gray-50 hover:from-indigo-50 hover:to-purple-50 border-slate-300" # Default if not related
        end

      true ->
        "bg-gradient-to-r from-slate-50 to-gray-50 hover:from-indigo-50 hover:to-purple-50 border-slate-300" # Default
    end
  end

  # Helper function to get layer-specific styling
  defp get_layer_styling(layer_index) do
    case rem(layer_index, 4) do
      0 -> "border-l-4 border-l-blue-400 bg-gradient-to-r from-blue-50 to-slate-50"
      1 -> "border-l-4 border-l-emerald-400 bg-gradient-to-r from-emerald-50 to-slate-50"
      2 -> "border-l-4 border-l-amber-400 bg-gradient-to-r from-amber-50 to-slate-50"
      3 -> "border-l-4 border-l-purple-400 bg-gradient-to-r from-purple-50 to-slate-50"
    end
  end

  # Helper function to get item name styling based on layer
  defp get_item_name_styling(layer_index, has_children) do
    base_classes = if has_children do
      "font-bold text-lg tracking-wide" # Parent items are more prominent
    else
      "font-semibold text-base" # Leaf items are less prominent but still bold
    end

    color_class = case rem(layer_index, 4) do
      0 -> "text-blue-700"
      1 -> "text-emerald-700"
      2 -> "text-amber-700"
      3 -> "text-purple-700"
    end

    "#{base_classes} #{color_class}"
  end

  defp initialize_ingredient_costs(materials_tree) do
    # Initialize all items with their market price as default cost
    materials_tree
    |> Enum.flat_map(fn {_layer, nodes} -> nodes end)
    |> Enum.reduce(%{}, fn %{item: item}, acc ->
      # Ensure we store integer values only
      price = case item.market_price do
        nil -> 0
        value when is_number(value) -> trunc(value)
        _ -> 0
      end
      Map.put(acc, item.id, price)
    end)
  end

  # Helper function to format abbreviated numbers for large values
  defp format_abbreviated_number(number) when number >= 1_000_000_000 do
    abbreviated = number / 1_000_000_000
    formatted = Float.to_string(abbreviated, decimals: 1)
    trimmed = String.replace(formatted, ~r/\.0$/, "")
    trimmed <> "B"
  end

  defp format_abbreviated_number(number) when number >= 1_000_000 do
    abbreviated = number / 1_000_000
    formatted = Float.to_string(abbreviated, decimals: 1)
    trimmed = String.replace(formatted, ~r/\.0$/, "")
    trimmed <> "M"
  end

  defp format_abbreviated_number(_number), do: nil

  defp get_item_layer(item_id, all_nodes) do
    # Find which layer this item is in
    all_nodes
    |> Enum.find_value(fn {layer_str, nodes} ->
      if Enum.any?(nodes, &(&1.item.id == item_id)) do
        String.to_integer(layer_str)
      else
        nil
      end
    end) || 0
  end

  # Helper function to initialize expanded nodes - all nodes start expanded by default
  defp initialize_expanded_nodes(materials_tree) do
    materials_tree
    |> Enum.flat_map(fn {_layer, nodes} -> nodes end)
    |> Enum.reduce(%{}, fn %{item: item}, acc ->
      Map.put(acc, item.id, true)
    end)
  end
  # Helper function to get all descendant IDs for a given item
  defp get_all_descendant_ids(item_id, materials_tree) do
    item_layer = get_item_layer(item_id, materials_tree)
    get_descendants_recursive(item_id, item_layer + 1, materials_tree, [])
  end

  defp get_descendants_recursive(parent_id, layer, materials_tree, acc) do
    children = find_children(parent_id, layer, materials_tree)

    if Enum.empty?(children) do
      acc
    else
      child_ids = Enum.map(children, & &1.item.id)
      new_acc = acc ++ child_ids

      # Recursively get descendants of each child
      Enum.reduce(children, new_acc, fn %{item: child_item}, current_acc ->
        get_descendants_recursive(child_item.id, layer + 1, materials_tree, current_acc)
      end)
    end
  end

  # Helper function to update an item in the materials tree
  defp update_item_in_materials_tree(materials_tree, updated_item) do
    materials_tree
    |> Enum.map(fn {layer_key, nodes} ->
      updated_nodes =
        nodes
        |> Enum.map(fn node ->
          if node.item.id == updated_item.id do
            %{node | item: updated_item}
          else
            node
          end
        end)

      {layer_key, updated_nodes}
    end)
    |> Enum.into(%{})
  end
end

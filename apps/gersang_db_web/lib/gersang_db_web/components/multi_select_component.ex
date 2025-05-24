defmodule GersangDbWeb.MultiSelectComponent do
  use GersangDbWeb, :live_component

  @default_options ["food", "toy", "boy", "girl", "animal", "plant"]

  @impl true
  def render(assigns) do
    # items_list and options_list are now expected to be in assigns
    ~H"""
    <div>
      <.input
        field={@form[@field]}
        value={item_list_to_string(@items_list)}
        type="hidden"
        label={@label}
        placeholder="Comma separated items"
      />

      <div class="">
        <div
          id="items-display"
          class="mt-1 flex flex-wrap items-center justify-between w-full rounded-md border border-gray-300 shadow-sm px-3 py-2 min-h-[38px] bg-white cursor-pointer"
          aria-live="polite"
          phx-click="toggle_options"
          phx-target={@myself}
        >
          <div class="flex flex-wrap items-center">
            <%= if Enum.empty?(@items_list) do %>
              <span class="text-gray-400 text-xs"><%= assigns[:placeholder] || "Select items" %></span>
            <% else %>
              <%= for item <- @items_list do %>
                <span
                  class="mr-1 inline-flex items-center px-3 py-1 rounded-md text-xs font-semibold text-white bg-pink-500 hover:bg-pink-700 hover:shadow-md cursor-pointer"
                  phx-click={remove_item(item, assigns)}
                >
                  <%= item %>
                </span>
              <% end %>
            <% end %>
          </div>
          <svg
            class={"w-5 h-5 text-gray-400 transition-transform duration-200 ease-in-out #{if @show_options, do: "rotate-90"}"}
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path fill-rule="evenodd" d="M8.22 5.22a.75.75 0 011.06 0l4.25 4.25a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 010-1.06z" clip-rule="evenodd" />
          </svg>
        </div>

        <%= if @show_options do %>
          <div id="options-container" class="mt-1 border border-gray-300 rounded-md shadow-sm bg-white p-2">
            <ul class="space-y-1">
              <%= for option <- @options_list do %>
                <li
                  class={"flex items-center p-2 rounded-md cursor-pointer #{if option in @items_list, do: "hover:bg-pink-100", else: "hover:bg-gray-100"}"}
                  phx-click={if option in @items_list, do: remove_item(option, assigns), else: add_item(option, assigns)}
                >
                  <%= if option in @items_list do %>
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5 mr-2 text-blue-500">
                      <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z" clip-rule="evenodd" />
                    </svg>
                  <% else %>
                    <div class="w-5 h-5 mr-2"></div>
                  <% end %>
                  <span class="text-sm text-gray-700"><%= option %></span>
                </li>
              <% end %>
            </ul>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    # Use the form from the incoming assigns, which reflects the latest input
    form = assigns.form

    items_list = Phoenix.HTML.Form.input_value(form, assigns.field) || []

    options_to_use = assigns[:options] || @default_options

    socket =
      socket
      |> assign(assigns) # Apply all assigns from parent or LiveView form updates
      |> assign(:items_list, items_list) # Always update items_list from the current form input
      |> assign_new(:options_list, fn -> Enum.sort(options_to_use) end) # Initialize if not present
      |> assign_new(:show_options, fn -> false end)            # Initialize if not present

    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_options", _params, socket) do
    {:noreply, assign(socket, :show_options, not socket.assigns.show_options)}
  end

  @impl true
  def handle_event("update_list", %{"new_items_list" => new_items_list}, socket) do
    socket =
      socket
      |> assign(:items_list, new_items_list) # Update the list used for rendering items

    {:noreply, socket}
  end

  defp item_list_to_string(items) when is_binary(items) do
    items
  end

  defp item_list_to_string(items) when is_list(items) do
    items
    |> trim_items()
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp item_list_to_string(_), do: ""

  defp item_list_to_string(items, selected_option) when is_list(items) do
    if selected_option in items do
      items
      |> item_list_to_string()
    else
      [selected_option | trim_items(items)]
      |> item_list_to_string()
    end
  end

  defp item_list_to_string(items, selected_option) when is_binary(items) do
    "#{selected_option},#{trim_items(items)}"
    |> item_list_to_string()
  end

  defp trim_items(items) when is_list(items) do
    items
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp trim_items(items) when is_binary(items) do
    items
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  # Helper to convert form input value (string or list) to a canonical list of items
  defp form_input_to_canonical_list(form_input_value) do
    cond do
      is_list(form_input_value) ->
        form_input_value
        |> trim_items() # Ensure all elements are trimmed and no empty strings
        |> Enum.uniq()
        |> Enum.sort()
      is_binary(form_input_value) ->
        form_input_value
        |> String.split(",", trim: true) # Split and trim parts
        |> trim_items() # Further ensure all elements are trimmed and no empty strings
        |> Enum.uniq()
        |> Enum.sort()
      true ->
        [] # Handles nil or other unexpected types, defaulting to an empty list
    end
  end

  defp add_item(item, assigns) do
    {updated_params, new_items_list} = update_items(%{add: item}, assigns)

    JS.push("update_list", value: %{"new_items_list" => new_items_list}, target: assigns.myself)
    |> JS.push("validate", value: %{"gersang_item" => updated_params}, target: assigns.target_handler)
  end

  defp remove_item(item, assigns) do
    {updated_params, new_items_list} = update_items(%{remove: item}, assigns)

    JS.push("update_list", value: %{"new_items_list" => new_items_list}, target: assigns.myself)
    |> JS.push("validate", value: %{"gersang_item" => updated_params}, target: assigns.target_handler)
  end

  defp update_items(%{add: item}, assigns) do
    # Read current items from the form input value
    current_form = assigns.form
    current_items_list = assigns.items_list

    # Prepare new list of items for display and for the input field
    updated_items_list =
      current_items_list
      |> item_list_to_string(String.trim(item))
      |> String.split(",")

    # Update the form params with the new items string
    # Assumes form.params is a map and "items" is the key.
    updated_params = Map.put(current_form.params || %{}, assigns.field, updated_items_list)

    {updated_params, updated_items_list}
  end

  defp update_items(%{remove: item}, assigns) do
    current_form = assigns.form
    # Ensure we are working with a list of strings for current_items_list
    current_items_list = assigns.items_list

    # Remove the item
    updated_items_list = current_items_list -- [String.trim(item)]

    # Update the form params with the new items list
    updated_params = Map.put(current_form.params || %{}, assigns.field, updated_items_list)

    {updated_params, updated_items_list}
  end
end

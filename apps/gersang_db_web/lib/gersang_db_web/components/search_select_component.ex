defmodule GersangDbWeb.Component.SearchSelectComponent do
  use GersangDbWeb, :live_component
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative flex-1" phx-click-away="close_dropdown" phx-target={@myself}>
      <!-- Hidden input field that maintains the actual form value -->
      <div class="hidden">
        <.input
          field={@form[@field]}
          value={@selected_value}
          type="hidden"
          label={@label}
        />
      </div>

      <!-- Search input field -->
      <div class="relative">
        <label class="block text-sm font-bold leading-6 text-gray-900">
          <%= @label %>
        </label>
        <div class="relative mt-2">
          <input
            id={"search-#{@field}"}
            type="text"
            value={@search_query}
            placeholder={@placeholder || "Type to search..."}
            class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-zinc-600 sm:text-sm sm:leading-6"
            phx-focus="focus_search"
            phx-keyup="filter_options"
            phx-keydown="handle_keydown"
            phx-debounce="300"
            phx-target={@myself}
            autocomplete="off"
          />

          <!-- Clear button -->
          <%= if @search_query != "" do %>
            <button
              type="button"
              class="absolute inset-y-0 right-0 flex items-center pr-3"
              phx-click="clear_search"
              phx-target={@myself}
            >
              <svg class="h-5 w-5 text-gray-400 hover:text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          <% end %>
        </div>
      </div>

      <!-- Dropdown options -->
      <%= if @show_dropdown do %>
        <div
          id={"dropdown-#{@field}"}
          class="absolute z-10 mt-1 w-full bg-white shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm"
        >
          <%= if Enum.empty?(@filtered_options) do %>
            <div class="px-4 py-2 text-gray-500 text-sm">
              No options found
            </div>
          <% else %>
            <%= for {option, index} <- Enum.with_index(@filtered_options) do %>              <div
                class={"cursor-pointer select-none relative py-2 pl-3 pr-9 hover:bg-gray-100 #{if index == @highlighted_index, do: "bg-gray-100"}"}
                phx-click={select_item(option, %{
                  field: @field,
                  options_map: @options_map,
                  myself: @myself,
                  target_handler: @target_handler,
                  form: %{name: @form.name}
                })}
              >
                <span class={"block truncate #{if find_value_for_label(option, @options_map) == @selected_value, do: "font-semibold", else: "font-normal"}"}>
                  <%= option %>
                </span>

                <%= if find_value_for_label(option, @options_map) == @selected_value do %>
                  <span class="absolute inset-y-0 right-0 flex items-center pr-4 text-blue-600">
                    <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z" clip-rule="evenodd" />
                    </svg>
                  </span>
                <% end %>
              </div>
            <% end %>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    # Get the current form value
    form = assigns.form
    raw_current_value = Phoenix.HTML.Form.input_value(form, assigns.field)

    # Ensure current_value is converted to string for consistent comparison
    current_value =
      case raw_current_value do
        nil -> ""
        "" -> ""
        val when is_integer(val) -> to_string(val)
        val when is_binary(val) -> val
        val -> to_string(val)
      end

    # Use provided options or default
    options_to_use = assigns[:options]

    # Normalize options to handle both string lists and {label, value} tuples
    {option_labels, option_map} = normalize_options(options_to_use)

    # Find the label for the current value
    current_label =
      case find_label_for_value(current_value, option_map) do
        nil -> current_value
        label -> label
      end

    socket =
      socket
      |> assign(assigns)
      |> assign(:selected_value, current_value)
      |> assign(:search_query, current_label)
      |> assign(:options_list, option_labels)
      |> assign(:options_map, option_map)
      |> assign_new(:filtered_options, fn -> option_labels end)
      |> assign_new(:show_dropdown, fn -> false end)
      |> assign_new(:highlighted_index, fn -> 0 end)

    {:ok, socket}
  end

  @impl true
  def handle_event("focus_search", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_dropdown, true)
     |> assign(:highlighted_index, 0)
     |> filter_options_by_query()}
  end

  @impl true
  def handle_event("handle_keydown", %{"key" => "ArrowDown"}, socket) do
    max_index = length(socket.assigns.filtered_options) - 1
    new_index = min(socket.assigns.highlighted_index + 1, max_index)
    {:noreply, assign(socket, :highlighted_index, new_index)}
  end
  @impl true
  def handle_event("handle_keydown", %{"key" => "ArrowUp"}, socket) do
    new_index = max(socket.assigns.highlighted_index - 1, 0)
    {:noreply, assign(socket, :highlighted_index, new_index)}
  end

  @impl true
  def handle_event("handle_keydown", %{"key" => "Enter"}, socket) do
    if socket.assigns.show_dropdown and length(socket.assigns.filtered_options) > 0 do
      selected_option = Enum.at(socket.assigns.filtered_options, socket.assigns.highlighted_index)
      if selected_option do
        # Convert label to value using the options map
        value = find_value_for_label(selected_option, socket.assigns.options_map)

        # Update form and trigger validation manually
        form = socket.assigns.form
        updated_params = Map.put(form.params || %{}, to_string(socket.assigns.field), value)

        # Send validation event to parent if target_handler is provided
        if socket.assigns[:target_handler] do
          send_update(socket.assigns.target_handler, %{
            validate: %{form.name => updated_params}
          })
        end

        socket =
          socket
          |> assign(:selected_value, value)
          |> assign(:search_query, selected_option)  # Display the label in search box
          |> assign(:show_dropdown, false)

        {:noreply, socket}
      else
        {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("handle_keydown", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, :show_dropdown, false)}
  end

  @impl true
  def handle_event("handle_keydown", _params, socket) do
    {:noreply, socket}
  end
  @impl true
  def handle_event("filter_options", %{"value" => query}, socket) do
    socket =
      socket
      |> assign(:search_query, query)
      |> assign(:highlighted_index, 0)
      |> filter_options_by_query()

    {:noreply, socket}
  end

  @impl true
  def handle_event("clear_search", _params, socket) do
    socket =
      socket
      |> assign(:search_query, "")
      |> assign(:highlighted_index, 0)
      |> assign(:show_dropdown, true)
      |> filter_options_by_query()

    {:noreply, socket}
  end
  @impl true
  def handle_event("select_option", %{"option" => option}, socket) do
    # Convert label to value using the options map
    value = find_value_for_label(option, socket.assigns.options_map)

    socket =
      socket
      |> assign(:selected_value, value)
      |> assign(:search_query, option)  # Display the label in search box
      |> assign(:show_dropdown, false)

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_dropdown", _params, socket) do
    {:noreply, assign(socket, :show_dropdown, false)}
  end

  defp filter_options_by_query(socket) do
    query = String.downcase(String.trim(socket.assigns.search_query))

    filtered =
      if query == "" do
        socket.assigns.options_list
      else
        Enum.filter(socket.assigns.options_list, fn option ->
          String.contains?(String.downcase(option), query)
        end)
      end

    assign(socket, :filtered_options, filtered)
  end

  # Helper function to normalize options - handles both string lists and {label, value} tuples
  defp normalize_options(options) when is_list(options) do
    if Enum.empty?(options) do
      {[], %{}}
    else
      case hd(options) do
        {_label, _value} ->
          # Handle {label, value} tuples
          option_labels = Enum.map(options, fn {label, _value} -> label end)
          option_map = Enum.into(options, %{}, fn {label, value} -> {label, value} end)
          {option_labels, option_map}

        _ ->
          # Handle plain string list
          option_labels = options
          option_map = Enum.into(options, %{}, fn opt -> {opt, opt} end)
          {option_labels, option_map}
      end
    end
  end

  defp normalize_options(_), do: {[], %{}}
  # Helper function to find label for a given value
  defp find_label_for_value(value, option_map) do
    # Convert value to string for consistent comparison
    value_str = to_string(value)

    Enum.find_value(option_map, fn {label, val} ->
      val_str = to_string(val)
      if val_str == value_str, do: label, else: nil
    end)
  end
  # Helper function to find value for a given label
  defp find_value_for_label(label, option_map) do
    Map.get(option_map, label, label)
  end
  # Function to handle item selection with JS.push for validation
  defp select_item(option, assigns) do
    # Extract only the essential data needed to avoid serialization issues
    field = assigns.field
    options_map = assigns.options_map
    myself = assigns.myself
    target_handler = assigns.target_handler
    form_name = assigns.form.name

    # Convert label to value using the options map
    value = find_value_for_label(option, options_map)

    # Build params with minimal data
    field_param = to_string(field)
    updated_params = %{field_param => value}

    # Use JS.push to update the component and trigger validation
    JS.push("select_option", value: %{"option" => option}, target: myself)
    |> JS.push("validate", value: %{form_name => updated_params}, target: target_handler)
  end
end

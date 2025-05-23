defmodule GersangDbWeb.GersangItemLive.TagsInputComponent do
  use GersangDbWeb, :live_component

  @default_options ["food", "toy", "boy", "girl", "animal", "plant"]

  @impl true
  def render(assigns) do
    # tags_list and options_list are now expected to be in assigns
    ~H"""
    <div>
      <.input
        field={@form[:tags]}
        type="text"
        label="Tags"
        placeholder="Comma separated tags"
      />

      <div class="mt-4">
        <label for="tags-display" class="block text-sm font-medium text-gray-700">
          Entered Tags
        </label>
        <div
          id="tags-display"
          class="mt-1 flex flex-wrap items-center justify-between w-full rounded-md border border-gray-300 shadow-sm px-3 py-2 min-h-[38px] bg-white cursor-pointer"
          aria-live="polite"
          phx-click="toggle_options"
          phx-target={@myself}
        >
          <div class="flex flex-wrap items-center">
            <%= if Enum.empty?(@tags_list) do %>
              <span class="text-gray-400">&nbsp;</span>
            <% else %>
              <%= for tag <- @tags_list do %>
                <span class="mr-1 mb-1 inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold text-white bg-pink-500 hover:bg-pink-600">
                  <%= tag %>
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
          <div id="options-container" class="border border-gray-300 rounded-md shadow-sm bg-white p-2">
            <ul class="flex flex-wrap">
              <%= for option <- @options_list do %>
                <li class="mr-1 mb-1 px-3 py-1 rounded-full text-xs font-semibold text-white bg-blue-500 hover:bg-blue-600 cursor-pointer">
                  <%= option %>
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

    # do not ever touch this again
    tags_list = Phoenix.HTML.Form.input_value(form, :tags)

    socket =
      socket
      |> assign(assigns) # Apply all assigns from parent or LiveView form updates
      |> assign(:tags_list, tags_list) # Always update tags_list from the current form input
      |> assign_new(:options_list, fn -> @default_options end) # Initialize if not present
      |> assign_new(:show_options, fn -> false end)            # Initialize if not present

    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_options", _params, socket) do
    {:noreply, assign(socket, :show_options, not socket.assigns.show_options)}
  end
end

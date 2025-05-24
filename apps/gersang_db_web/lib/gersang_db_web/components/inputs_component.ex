defmodule GersangDbWeb.InputsComponent do
  use GersangDbWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="">
      <.input
        field={@form[@field]}
        type="select"
        label={@label}
        options={@options}
        required={@required}
      />
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end

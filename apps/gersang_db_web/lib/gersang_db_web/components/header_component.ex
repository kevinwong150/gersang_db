defmodule GersangDbWeb.HeaderComponent do
  use Phoenix.Component
  use Phoenix.VerifiedRoutes, router: GersangDbWeb.Router, endpoint: GersangDbWeb.Endpoint

  def header_component(assigns) do
    ~H"""
    <header class="bg-theme-primary text-theme-secondary-light p-4">
      <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-3xl font-bold">
          <.link href={~p"/gersang"}>Gersang DB</.link>
        </h1>
        <nav>
          <ul>
            <li>
              <.link
                href={~p"/gersang/items"}
                class="text-theme-primary-light hover:text-theme-secondary-light"
              >
                Items
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    </header>
    """
  end
end

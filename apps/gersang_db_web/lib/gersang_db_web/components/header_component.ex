defmodule GersangDbWeb.HeaderComponent do
  use Phoenix.Component
  use Phoenix.VerifiedRoutes, router: GersangDbWeb.Router, endpoint: GersangDbWeb.Endpoint
  def header_component(assigns) do
    ~H"""
    <header class="w-full bg-theme-primary-light text-theme-secondary-light p-4 sticky top-0 z-50">
      <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-3xl font-bold">
          <.link href={~p"/gersang"}>Gersang DB</.link>
        </h1>
        <nav>
          <ul class="flex space-x-4">
            <li>
              <.link
                href={~p"/gersang/items"}
                class="text-theme-secondary-light hover:text-theme-secondary-light"
              >
                Items
              </.link>
            </li>            <li>
              <.link
                href={~p"/gersang/recipes"}
                class="text-theme-secondary-light hover:text-theme-secondary-light"
              >
                Recipes
              </.link>
            </li>
            <li>
              <.link
                href={~p"/gersang/recipe_specs"}
                class="text-theme-secondary-light hover:text-theme-secondary-light"
              >
                Recipe Specs
              </.link>
            </li>
            <li>
              <.link
                href={~p"/gersang/damage_calculator"}
                class="text-theme-secondary-light hover:text-theme-secondary-light"
              >
                Damage Calculator
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    </header>
    """
  end
end

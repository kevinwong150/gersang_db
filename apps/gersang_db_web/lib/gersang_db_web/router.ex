defmodule GersangDbWeb.Router do
  use GersangDbWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GersangDbWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GersangDbWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/gersang", GersangController, :index

    live "/gersang/items", GersangItemLive.Index, :index
    live "/gersang/items/new", GersangItemLive.Index, :new
    live "/gersang/items/:id/edit", GersangItemLive.Index, :edit
    live "/gersang/items/:id", GersangItemLive.Show, :show
    live "/gersang/items/:id/show/edit", GersangItemLive.Show, :edit

    live "/gersang/recipes", RecipeLive.Index, :index
    live "/gersang/recipes/new", RecipeLive.Index, :new
    live "/gersang/recipes/:product_id/:recipe_spec_id/edit", RecipeLive.Index, :edit
    live "/gersang/recipes/:product_id/:recipe_spec_id", RecipeLive.Show, :show

    live "/gersang/recipe_specs", RecipeSpecLive.Index, :index
    live "/gersang/recipe_specs/new", RecipeSpecLive.Index, :new
    live "/gersang/recipe_specs/:id/edit", RecipeSpecLive.Index, :edit
    live "/gersang/recipe_specs/:id", RecipeSpecLive.Show, :show
    live "/gersang/recipe_specs/:id/show/edit", RecipeSpecLive.Show, :edit

    live "/gersang/damage_calculator", DamageCalculatorLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GersangDbWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gersang_db_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GersangDbWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

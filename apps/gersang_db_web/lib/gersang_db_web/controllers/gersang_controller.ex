defmodule GersangDbWeb.GersangController do
  use GersangDbWeb, :controller

  alias GersangDb.GersangItems

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    items = GersangItems.list_items()
    |> IO.inspect(label: :items)


    render(conn, :index, items: items)
  end
end

defmodule GersangDbWeb.GersangController do
  use GersangDbWeb, :controller

  alias GersangDb.GersangItem

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    items = GersangItem.list_items()

    render(conn, :index, items: items)
  end
end

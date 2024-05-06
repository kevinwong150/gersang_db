# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GersangDb.Repo.insert!(%GersangDb.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

gersang_items_attrs = [
  %{
    name: "Moon Seal",
    market_price: 2000
  },
  %{
    name: "Sun Seal",
    market_price: 1000
  }
]

Enum.map(gersang_items_attrs, fn attr ->
  GersangDb.GersangItems.create_item(attr)
end)

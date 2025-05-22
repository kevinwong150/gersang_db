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

gersang_item_attrs = [
  %{
    name: "Moon Seal",
    market_price: 2000
  },
  %{
    name: "Sun Seal",
    market_price: 1000
  },
  %{
    name: "Piece of Deities(Thunder)",
    market_price: 850_000
  },
  %{
    name: "Piece of Deities(Earth)",
    market_price: 890_000
  },
  %{
    name: "Piece of Deities(Wind)",
    market_price: 1_400_000
  },
  %{
    name: "Piece of Deities(Water)",
    market_price: 1_980_000
  },
  %{
    name: "Piece of Deities(Flame)",
    market_price: 3_000_000
  },
  %{
    name: "Small Elemental Stone of Flame",
    market_price: 940_000
  },
  %{
    name: "Small Elemental Stone of Water",
    market_price: 850_000
  },
  %{
    name: "Small Elemental Stone of Wind",
    market_price: 790_000
  },
  %{
    name: "Small Elemental Stone of Thunder",
    market_price: 850_000
  },
  %{
    name: "Small Elemental Stone of Earth",
    market_price: 8_500_000
  }
]

Enum.map(gersang_item_attrs, fn attr ->
  GersangDb.GersangItem.create_item(attr)
end)

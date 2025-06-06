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
    name: "Sealed Power Piece",
    market_price: 1600000
  },
  %{
    name: "Sealed Power Shard",
    market_price: 17000000
  },
  %{
    name: "Yellow Force Stone",
    market_price: 0
  },
  %{
    name: "Red Force Stone",
    market_price: 0
  },
  %{
    name: "Blue Force Stone",
    market_price: 0
  },
  %{
    name: "Moon Seal",
    market_price: 2000
  },
  %{
    name: "Sun Seal",
    market_price: 1000
  },
  %{
    name: "Five color powder",
    market_price: 1500000
  },
  %{
    name: "Force of Deities(Thunder)",
    market_price: 35000000
  },
  %{
    name: "Force of Deities(Earth)",
    market_price: 35000000
  },
  %{
    name: "Force of Deities(Wind)",
    market_price: 35000000
  },
  %{
    name: "Force of Deities(Water)",
    market_price: 35000000
  },
  %{
    name: "Force of Deities(Flame)",
    market_price: 35000000
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
  },
  %{
    name: "Force Beads(Flame)",
    market_price: 0
  },
  %{
    name: "Force Beads(Water)",
    market_price: 0
  },
  %{
    name: "Force Beads(Wind)",
    market_price: 0
  },
  %{
    name: "Force Beads(Thunder)",
    market_price: 0
  },
  %{
    name: "Force Beads(Earth)",
    market_price: 0
  },
  %{
    name: "Fragmented Force Beads(Flame)",
    market_price: 2900000
  },
  %{
    name: "Fragmented Force Beads(Water)",
    market_price: 2_800_000
  },
  %{
    name: "Fragmented Force Beads(Wind)",
    market_price: 275_000
  },
  %{
    name: "Fragmented Force Beads(Thunder)",
    market_price: 1200000
  },
  %{
    name: "Fragmented Force Beads(Earth)",
    market_price: 500000
  },
  %{
    name: "Flame Stone",
    market_price: 1000000
  },
  %{
    name: "Frozen Stone",
    market_price: 1000000
  },
  %{
    name: "maple stone",
    market_price: 1000000
  },
  %{
    name: "Thunder Soul Stone",
    market_price: 1000000
  },
  %{
    name: "Earth specter stone",
    market_price: 500000
  },
  %{
    name: "Flame specter stone",
    market_price: 4000000
  },
  %{
    name: "Water specter stone",
    market_price: 2000000
  },
  %{
    name: "Wind specter stone",
    market_price: 2000000
  },
  %{
    name: "Thunder specter stone",
    market_price: 2000000
  },
]

Enum.map(gersang_item_attrs, fn attr ->
  # GersangDb.GersangItem.create_item(attr)
end)

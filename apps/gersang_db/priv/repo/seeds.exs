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
    market_price: 1300000
  },
  %{
    name: "Red Force Stone",
    market_price: 8000
  },
  %{
    name: "Blue Force Stone",
    market_price: 50000
  },
  %{
    name: "Moon Seal",
    market_price: 8000000
  },
  %{
    name: "Sun Seal",
    market_price: 5000000
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
  %{name: "Wolfporia", market_price: 60000},
  %{name: "Honeysuckle", market_price: 30000},
  %{name: "Thousand Year Lake Plant", market_price: 60000},
  %{name: "Sedum Album", market_price: 60000},
  %{name: "Honeyweed", market_price: 100000},
  %{name: "Snow Ginseng", market_price: 70000},
  %{name: "Sang Hwang Mushroom", market_price: 10000},
  %{name: "Windflower", market_price: 80000},
  %{name: "Kid Ginseng", market_price: 80000},
  %{name: "Solar Flower", market_price: 80000},
  %{name: "Flame Flower", market_price: 80000},
  %{name: "Seokgyun Swamp", market_price: 5000},
  %{name: "Mountain Flower", market_price: 120000},
  %{name: "Prickly Pear", market_price: 120000},
  %{name: "Golden lotus", market_price: 120000},
  %{name: "Poor Essence", market_price: 300000},
  %{name: "Fair Essence", market_price: 5000000},
  %{name: "Good Essence", market_price: 2000000},
  %{name: "Life Essence", market_price: 2500000},
  %{name: "Imoogi's scale", market_price: 2000000},
  %{name: "Dazzleweed", market_price: 80000},
  %{name: "Food", market_price: 500000},
  %{name: "Wandering Artist's Phrase", market_price: 10000000},
  %{name: "Nine-Leafed Plant", market_price: 5000},
  %{name: "Mana Pill(1D)", market_price: 5000000},
  %{name: "Temporal Powder", market_price: 28000000},
  %{name: "Root of life", market_price: 50000},
  %{name: "Mysterious medicine of death", market_price: 2000000},
  %{name: "Hardened Wood", market_price: 600000},
  %{name: "Storage Ticket", market_price: 60000000},
  %{name: "Mysterious medicine of life", market_price: 1400000000},
  %{name: "Mana Pill(15D)", market_price: 50000000},
  %{name: "Devil wing - 1day", market_price: 8500000},
  %{name: "Immortality", market_price: 700000},
  %{name: "The Art of War Vol.24", market_price: 4000000},
  %{name: "Tranquilizer", market_price: 1600000},
  %{name: "Five color powder", market_price: 1500000},
  %{name: "Polish Powder", market_price: 1800000},
  %{name: "Gold Powder", market_price: 400000},
  %{name: "Red Powder", market_price: 1000000},
  %{name: "Black Powder", market_price: 500000},
  %{name: "White Powder", market_price: 300000},
  %{name: "Blue Powder", market_price: 700000},
  %{name: "Obsidian Ring", market_price: 500000},
  %{name: "Zhuge Liang\'s Ring", market_price: 280000000},
  %{name: "Demon Ring", market_price: 350000000},
  %{name: "Five color Crystal", market_price: 0},
  %{name: "Powered Bloodstone", market_price: 68000000},
  %{name: "Powered Obsidian", market_price: 45000000},
  %{name: "Powered Fisheye", market_price: 41000000},
  %{name: "Powered Goldstone", market_price: 36000000},
  %{name: "Powered White Crystal", market_price: 33000000},
  %{name: "Carved Fisheye", market_price: 0},
  %{name: "Carved Bloodstone", market_price: 0},
  %{name: "Carved Obsidian", market_price: 0},
  %{name: "Carved Goldstone", market_price: 0},
  %{name: "Carved White Crystal", market_price: 0},
  %{name: "Soul Crystal", market_price: 6600000},
  %{name: "Bloodstone", market_price: 0},
  %{name: "Obsidian", market_price: 0},
  %{name: "Fisheye", market_price: 0},
  %{name: "Goldstone", market_price: 0},
  %{name: "White Crystal", market_price: 0}
]

Enum.map(gersang_item_attrs, fn attr ->
  GersangDb.GersangItem.create_item(attr)
end)

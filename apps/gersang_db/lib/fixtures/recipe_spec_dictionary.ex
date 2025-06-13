defmodule Data.Dictionary.RecipeSpecs do
  @moduledoc """
  RecipeSpec dictionary for Gersang.
  """
  alias Data.Dictionary.Items

  def recipe_specs_dictionary do
    items = Items.list_items()
    fetch_item_name = fn item_key ->
      case items[item_key] do
        nil -> nil
        item -> item[:name]
      end
    end

    %{
      central_forge: [
        %{product_name: fetch_item_name.("five_color_crystal_powder_fragment"), production_fee: 3000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("sealed_power_shard"), production_fee: 500000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_virudhaka"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_virupaksa"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_dhritarashtra"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_vaisravana"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_awa_dhritara"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_awa_virudha"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_vajrayaksa"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_kundali"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_yamantaka"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_trailokyavijaya"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ultra_guardian_acala"), production_fee: 0, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_beads_flame"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_beads_water"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_beads_wind"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_beads_thunder"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_beads_earth"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("nightmare_beads_flame"), production_fee: 5000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("nightmare_beads_water"), production_fee: 5000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("nightmare_beads_wind"), production_fee: 5000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("nightmare_beads_thunder"), production_fee: 5000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("elemental_stone_of_flame"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("elemental_stone_of_water"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("elemental_stone_of_wind"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("elemental_stone_of_thunder"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("elemental_stone_of_earth"), production_fee: 2000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_of_deities_flame"), production_fee: 500000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_of_deities_water"), production_fee: 500000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_of_deities_wind"), production_fee: 500000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_of_deities_thunder"), production_fee: 500000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("force_of_deities_earth"), production_fee: 500000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("burning_deities_seal"), production_fee: 3000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("frozen_deities_seal"), production_fee: 3000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("backflowing_deities_seal"), production_fee: 3000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("lightning_deities_seal"), production_fee: 3000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("crashing_deities_seal"), production_fee: 3000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("wailing_mortidark_heart"), production_fee: 10000000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("crystal_of_flame"), production_fee: 300000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("crystal_of_water"), production_fee: 300000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("crystal_of_wind"), production_fee: 300000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("crystal_of_thunder"), production_fee: 300000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("crystal_of_earth"), production_fee: 300000, production_amount: 1, media: "Central Forge"},
        %{product_name: fetch_item_name.("ash_fear_jade"), production_fee: 10000000, production_amount: 1, media: "Central Forge"}
      ],
      weaponary: [
        %{product_name: fetch_item_name.("black_lotus_cannon"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("bell_of_black_lotus"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("white_lotus_marble"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("dragon_horn"), production_fee: 0, production_amount: 1, wage: 1000, workload: 150_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("frozen_needle"), production_fee: 0, production_amount: 1, wage: 1000, workload: 150_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("sky_scorcher"), production_fee: 0, production_amount: 1, wage: 1000, workload: 250_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("jumong_bow"), production_fee: 0, production_amount: 1, wage: 1000, workload: 250_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("golden_hook"), production_fee: 0, production_amount: 1, wage: 1000, workload: 250_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("taowu_fang"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("taoties_horn"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("qiong_qi_feather"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Weaponary"},
        %{product_name: fetch_item_name.("hundun_needle"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Weaponary"}
      ],
      armory: [
        %{product_name: fetch_item_name.("amaterasu_crown"), production_fee: 0, production_amount: 1, wage: 1000, workload: 150_000, media: "Armory"},
        %{product_name: fetch_item_name.("amaterasu_armor"), production_fee: 0, production_amount: 1, wage: 1000, workload: 150_000, media: "Armory"},
        %{product_name: fetch_item_name.("wons_glove"), production_fee: 0, production_amount: 1, wage: 1000, workload: 50_000, media: "Armory"}
      ],
      factory: [
        %{product_name: fetch_item_name.("advanced_taowu_fang"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Factory"},
        %{product_name: fetch_item_name.("advanced_taoties_horn"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Factory"},
        %{product_name: fetch_item_name.("advanced_qiong_qi_feather"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Factory"},
        %{product_name: fetch_item_name.("advanced_hundun_needle"), production_fee: 0, production_amount: 1, wage: 1000, workload: 100_000, media: "Factory"},
        %{product_name: fetch_item_name.("duis_ring"), production_fee: 0, production_amount: 1, wage: 1000, workload: 300_000, media: "Factory"},
        %{product_name: fetch_item_name.("king_chiyou_ring"), production_fee: 0, production_amount: 1, wage: 1000, workload: 300_000, media: "Factory"}
      ],
      alchemist: [
        %{product_name: fetch_item_name.("tranquilizer"), production_fee: 1000000, production_amount: 5, media: "Alchemist"},
        %{product_name: fetch_item_name.("temporal_powder"), production_fee: 5000, production_amount: 10, media: "Alchemist"},
        %{product_name: fetch_item_name.("five_color_powder"), production_fee: 500000, production_amount: 10, media: "Alchemist"},
        %{product_name: fetch_item_name.("polish_powder"), production_fee: 1000000, production_amount: 5, media: "Alchemist"},
        %{product_name: fetch_item_name.("gold_powder"), production_fee: 50000, production_amount: 20, media: "Alchemist"},
        %{product_name: fetch_item_name.("red_powder"), production_fee: 2500000, production_amount: 10, media: "Alchemist"},
        %{product_name: fetch_item_name.("black_powder"), production_fee: 1000000, production_amount: 20, media: "Alchemist"},
        %{product_name: fetch_item_name.("white_powder"), production_fee: 10000, production_amount: 20, media: "Alchemist"},
        %{product_name: fetch_item_name.("blue_powder"), production_fee: 300000, production_amount: 20, media: "Alchemist"},
        %{product_name: fetch_item_name.("sword_seal"), production_fee: 5000000, production_amount: 1, media: "Alchemist"},
        %{product_name: fetch_item_name.("component_seal"), production_fee: 5000000, production_amount: 1, media: "Alchemist"},
        %{product_name: fetch_item_name.("storage_ticket"), production_fee: 10000000, production_amount: 1, media: "Alchemist"},
        %{product_name: fetch_item_name.("mysterious_medicine_of_life"), production_fee: 10000000, production_amount: 1, media: "Alchemist"},
        %{product_name: fetch_item_name.("mana_pill_15d"), production_fee: 500000, production_amount: 1, media: "Alchemist"},
        %{product_name: fetch_item_name.("devil_wing_1day"), production_fee: 500000, production_amount: 2, media: "Alchemist"},
        %{product_name: fetch_item_name.("immortality"), production_fee: 500000, production_amount: 10, media: "Alchemist"},
        %{product_name: fetch_item_name.("wandering_artists_phrase"), production_fee: 2000000, production_amount: 1, media: "Alchemist"},
        %{product_name: fetch_item_name.("the_art_of_war_vol_24"), production_fee: 500000, production_amount: 5, media: "Alchemist"}
      ],
      metallurgist: [
        %{product_name: fetch_item_name.("bloodstone"), production_fee: 300000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("obsidian"), production_fee: 300000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("fisheye"), production_fee: 50000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("goldstone"), production_fee: 50000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("white_crystal"), production_fee: 50000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("carved_fisheye"), production_fee: 2000000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("carved_bloodstone"), production_fee: 5000000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("carved_obsidian"), production_fee: 5000000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("carved_goldstone"), production_fee: 2000000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("carved_white_crystal"), production_fee: 1000000, production_amount: 5, media: "Metallurgist"},
        %{product_name: fetch_item_name.("powered_bloodstone"), production_fee: 30000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("powered_obsidian"), production_fee: 20000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("powered_fisheye"), production_fee: 20000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("powered_goldstone"), production_fee: 10000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("powered_white_crystal"), production_fee: 10000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("soul_crystal"), production_fee: 3000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("amethyst_ring"), production_fee: 500000, production_amount: 2, media: "Metallurgist"},
        %{product_name: fetch_item_name.("zhuge_liang_ring"), production_fee: 30000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("demon_ring"), production_fee: 30000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("yellow_dragons_needle"), production_fee: 30000000, production_amount: 1, media: "Metallurgist"},
        %{product_name: fetch_item_name.("five_color_crystal"), production_fee: 10000000, production_amount: 1, media: "Metallurgist"}
      ],
      blacksmith: [
        %{product_name: fetch_item_name.("brass"), production_fee: 50000, production_amount: 30, media: "Blacksmith"},
        %{product_name: fetch_item_name.("bronze"), production_fee: 100000, production_amount: 30, media: "Blacksmith"},
        %{product_name: fetch_item_name.("iron_bar"), production_fee: 1500000, production_amount: 30, media: "Blacksmith"},
        %{product_name: fetch_item_name.("dark_iron_bar"), production_fee: 5000000, production_amount: 30, media: "Blacksmith"},
        %{product_name: fetch_item_name.("black_steel_ingot"), production_fee: 5000000, production_amount: 20, media: "Blacksmith"},
        %{product_name: fetch_item_name.("iron_clamp"), production_fee: 10000000, production_amount: 2, media: "Blacksmith"},
        %{product_name: fetch_item_name.("shining_iron_clamp"), production_fee: 30000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("yeraes_pickax"), production_fee: 5000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("hanchaes_hoe"), production_fee: 5000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("blue_moon_dragon"), production_fee: 20000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("demon_slayer"), production_fee: 20000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("jaryong"), production_fee: 50000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("duis_helmet"), production_fee: 75000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("duis_armor"), production_fee: 1250000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("spirit_gloves"), production_fee: 50000000, production_amount: 1, media: "Blacksmith"},
        %{product_name: fetch_item_name.("daejanggunpo"), production_fee: 30000000, production_amount: 1, media: "Blacksmith"}
      ],
    }
  end

  def list_recipe_specs do
    recipe_specs_dictionary()
    |> Enum.map(&flatten_items/1)
    |> Enum.filter(&!is_nil(&1))
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.to_list()
  end

  defp flatten_items({key, value}) when is_list(value) do
    value
  end

  defp flatten_items({key, value}) when is_map(value) do
    Enum.map(value, fn {k, v} ->
      flatten_items({k, v})
    end)
  end

  defp flatten_items({key, value})do
    nil
  end
end

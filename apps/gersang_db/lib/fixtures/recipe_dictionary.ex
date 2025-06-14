defmodule Data.Dictionary.Recipes do
  @moduledoc """
  Recipe dictionary for Gersang.
  """
  alias Data.Dictionary.Items

  def recipe_dictionary do
    items = Items.list_items()

    fetch_item_name = fn item_key ->
      case items[item_key] do
        nil -> nil
        item -> item[:name]
      end
    end

    %{
      central_forge: [
        %{
          product_item_name: fetch_item_name.("sealed_power_shard"),
          material_items: [
            %{name: fetch_item_name.("sealed_power_piece"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("five_color_crystal_powder_fragment"),
          material_items: [
            %{name: fetch_item_name.("five_color_crystal_powder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_virudhaka"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_blue_dragon"), material_amount: 1},
            %{name: fetch_item_name.("gold_egg"), material_amount: 1},
            %{name: fetch_item_name.("elemental_stone_of_thunder"), material_amount: 5},
            %{name: fetch_item_name.("force_beads_thunder"), material_amount: 3},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_virupaksa"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_white_tiger"), material_amount: 1},
            %{name: fetch_item_name.("silver_egg"), material_amount: 1},
            %{name: fetch_item_name.("elemental_stone_of_wind"), material_amount: 5},
            %{name: fetch_item_name.("force_beads_wind"), material_amount: 3},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_dhritarashtra"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_vermillion_bird"), material_amount: 1},
            %{name: fetch_item_name.("red_egg"), material_amount: 1},
            %{name: fetch_item_name.("elemental_stone_of_flame"), material_amount: 5},
            %{name: fetch_item_name.("force_beads_flame"), material_amount: 3},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_vaisravana"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_black_tortoise"), material_amount: 1},
            %{name: fetch_item_name.("sapphire_egg"), material_amount: 1},
            %{name: fetch_item_name.("elemental_stone_of_water"), material_amount: 5},
            %{name: fetch_item_name.("force_beads_water"), material_amount: 3},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_awa_dhritara"),
          material_items: [
            %{name: fetch_item_name.("ultra_guardian_dhritarashtra"), material_amount: 1},
            %{name: fetch_item_name.("red_egg"), material_amount: 2},
            %{name: fetch_item_name.("awaken_stone"), material_amount: 5},
            %{name: fetch_item_name.("tablet_of_memory_flame"), material_amount: 100},
            %{name: fetch_item_name.("memory_of_power"), material_amount: 100}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_awa_virudha"),
          material_items: [
            %{name: fetch_item_name.("ultra_guardian_virudhaka"), material_amount: 1},
            %{name: fetch_item_name.("gold_egg"), material_amount: 2},
            %{name: fetch_item_name.("awaken_stone"), material_amount: 5},
            %{name: fetch_item_name.("tablet_of_memory_thunder"), material_amount: 100},
            %{name: fetch_item_name.("memory_of_power"), material_amount: 100}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_vajrayaksa"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_black_tortoise"), material_amount: 1},
            %{name: fetch_item_name.("sapphire_egg"), material_amount: 1},
            %{name: fetch_item_name.("nightmare_beads_water"), material_amount: 2},
            %{name: fetch_item_name.("frozen_deities_seal"), material_amount: 2},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_kundali"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_blue_dragon"), material_amount: 1},
            %{name: fetch_item_name.("gold_egg"), material_amount: 1},
            %{name: fetch_item_name.("nightmare_beads_thunder"), material_amount: 2},
            %{name: fetch_item_name.("lightning_deities_seal"), material_amount: 2},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_yamantaka"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_white_tiger"), material_amount: 1},
            %{name: fetch_item_name.("silver_egg"), material_amount: 1},
            %{name: fetch_item_name.("nightmare_beads_wind"), material_amount: 2},
            %{name: fetch_item_name.("backflowing_deities_seal"), material_amount: 2},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_trailokyavijaya"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_vermillion_bird"), material_amount: 1},
            %{name: fetch_item_name.("red_egg"), material_amount: 1},
            %{name: fetch_item_name.("nightmare_beads_flame"), material_amount: 2},
            %{name: fetch_item_name.("burning_deities_seal"), material_amount: 2},
            %{name: fetch_item_name.("currency_note"), material_amount: 3},
            %{name: fetch_item_name.("source_of_power"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ultra_guardian_acala"),
          material_items: [
            %{name: fetch_item_name.("fortune_guardian_black_tortoise"), material_amount: 1},
            %{name: fetch_item_name.("fortune_guardian_blue_dragon"), material_amount: 1},
            %{name: fetch_item_name.("fortune_guardian_white_tiger"), material_amount: 1},
            %{name: fetch_item_name.("fortune_guardian_vermillion_bird"), material_amount: 1},
            %{name: fetch_item_name.("crashing_deities_seal"), material_amount: 2},
            %{name: fetch_item_name.("ash_fear_jade"), material_amount: 5},
            %{name: fetch_item_name.("wailing_mortidark_heart"), material_amount: 5},
            %{name: fetch_item_name.("sealed_scroll"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_beads_flame"),
          material_items: [
            %{name: fetch_item_name.("fragmented_force_beads_flame"), material_amount: 10},
            %{name: fetch_item_name.("small_elemental_stone_of_flame"), material_amount: 5},
            %{name: fetch_item_name.("flame_stone"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_beads_water"),
          material_items: [
            %{name: fetch_item_name.("fragmented_force_beads_water"), material_amount: 10},
            %{name: fetch_item_name.("small_elemental_stone_of_water"), material_amount: 5},
            %{name: fetch_item_name.("frozen_stone"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_beads_wind"),
          material_items: [
            %{name: fetch_item_name.("fragmented_force_beads_wind"), material_amount: 10},
            %{name: fetch_item_name.("small_elemental_stone_of_wind"), material_amount: 5},
            %{name: fetch_item_name.("maple_stone"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_beads_thunder"),
          material_items: [
            %{name: fetch_item_name.("fragmented_force_beads_thunder"), material_amount: 10},
            %{name: fetch_item_name.("small_elemental_stone_of_thunder"), material_amount: 5},
            %{name: fetch_item_name.("thunder_soul_stone"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_beads_earth"),
          material_items: [
            %{name: fetch_item_name.("fragmented_force_beads_earth"), material_amount: 10},
            %{name: fetch_item_name.("small_elemental_stone_of_earth"), material_amount: 5},
            %{name: fetch_item_name.("earth_specter_stone"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("nightmare_beads_flame"),
          material_items: [
            %{name: fetch_item_name.("dark_aura_crystal"), material_amount: 20},
            %{name: fetch_item_name.("elemental_stone_of_flame"), material_amount: 1},
            %{name: fetch_item_name.("flame_seal"), material_amount: 10},
            %{name: fetch_item_name.("sun_seal"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("nightmare_beads_water"),
          material_items: [
            %{name: fetch_item_name.("dark_aura_crystal"), material_amount: 20},
            %{name: fetch_item_name.("elemental_stone_of_water"), material_amount: 1},
            %{name: fetch_item_name.("water_seal"), material_amount: 10},
            %{name: fetch_item_name.("moon_seal"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("nightmare_beads_wind"),
          material_items: [
            %{name: fetch_item_name.("dark_aura_crystal"), material_amount: 20},
            %{name: fetch_item_name.("elemental_stone_of_wind"), material_amount: 1},
            %{name: fetch_item_name.("wind_seal"), material_amount: 10},
            %{name: fetch_item_name.("moon_seal"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("nightmare_beads_thunder"),
          material_items: [
            %{name: fetch_item_name.("dark_aura_crystal"), material_amount: 20},
            %{name: fetch_item_name.("elemental_stone_of_thunder"), material_amount: 1},
            %{name: fetch_item_name.("thunder_seal"), material_amount: 10},
            %{name: fetch_item_name.("sun_seal"), material_amount: 2},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("elemental_stone_of_flame"),
          material_items: [
            %{name: fetch_item_name.("small_elemental_stone_of_flame"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("elemental_stone_of_water"),
          material_items: [
            %{name: fetch_item_name.("small_elemental_stone_of_water"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("elemental_stone_of_wind"),
          material_items: [
            %{name: fetch_item_name.("small_elemental_stone_of_wind"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("elemental_stone_of_thunder"),
          material_items: [
            %{name: fetch_item_name.("small_elemental_stone_of_thunder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("elemental_stone_of_earth"),
          material_items: [
            %{name: fetch_item_name.("small_elemental_stone_of_earth"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_of_deities_flame"),
          material_items: [
            %{name: fetch_item_name.("piece_of_deities_flame"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_of_deities_water"),
          material_items: [
            %{name: fetch_item_name.("piece_of_deities_water"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_of_deities_wind"),
          material_items: [
            %{name: fetch_item_name.("piece_of_deities_wind"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_of_deities_thunder"),
          material_items: [
            %{name: fetch_item_name.("piece_of_deities_thunder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("force_of_deities_earth"),
          material_items: [
            %{name: fetch_item_name.("piece_of_deities_earth"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("burning_deities_seal"),
          material_items: [
            %{name: fetch_item_name.("ancient_flame_seal"), material_amount: 20},
            %{name: fetch_item_name.("force_of_deities_flame"), material_amount: 5},
            %{name: fetch_item_name.("small_elemental_stone_of_flame"), material_amount: 20},
            %{name: fetch_item_name.("flame_stone"), material_amount: 20},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("frozen_deities_seal"),
          material_items: [
            %{name: fetch_item_name.("ancient_water_seal"), material_amount: 20},
            %{name: fetch_item_name.("force_of_deities_water"), material_amount: 5},
            %{name: fetch_item_name.("small_elemental_stone_of_water"), material_amount: 20},
            %{name: fetch_item_name.("frozen_stone"), material_amount: 30},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("backflowing_deities_seal"),
          material_items: [
            %{name: fetch_item_name.("ancient_wind_seal"), material_amount: 20},
            %{name: fetch_item_name.("force_of_deities_wind"), material_amount: 5},
            %{name: fetch_item_name.("small_elemental_stone_of_wind"), material_amount: 20},
            %{name: fetch_item_name.("maple_stone"), material_amount: 30},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("lightning_deities_seal"),
          material_items: [
            %{name: fetch_item_name.("ancient_thunder_seal"), material_amount: 20},
            %{name: fetch_item_name.("force_of_deities_thunder"), material_amount: 5},
            %{name: fetch_item_name.("small_elemental_stone_of_thunder"), material_amount: 20},
            %{name: fetch_item_name.("thunder_soul_stone"), material_amount: 30},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("crashing_deities_seal"),
          material_items: [
            %{name: fetch_item_name.("ancient_earth_seal"), material_amount: 20},
            %{name: fetch_item_name.("force_of_deities_earth"), material_amount: 5},
            %{name: fetch_item_name.("small_elemental_stone_of_earth"), material_amount: 20},
            %{name: fetch_item_name.("earth_specter_stone"), material_amount: 30},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("wailing_mortidark_heart"),
          material_items: [
            %{name: fetch_item_name.("wailing_heart_flame"), material_amount: 10},
            %{name: fetch_item_name.("wailing_heart_water"), material_amount: 10},
            %{name: fetch_item_name.("wailing_heart_thunder"), material_amount: 10},
            %{name: fetch_item_name.("wailing_heart_wind"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("crystal_of_flame"),
          material_items: [
            %{name: fetch_item_name.("crystal_fragment_flame"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("crystal_of_water"),
          material_items: [
            %{name: fetch_item_name.("crystal_fragment_water"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("crystal_of_wind"),
          material_items: [
            %{name: fetch_item_name.("crystal_fragment_wind"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("crystal_of_thunder"),
          material_items: [
            %{name: fetch_item_name.("crystal_fragment_thunder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("crystal_of_earth"),
          material_items: [
            %{name: fetch_item_name.("crystal_fragment_earth"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("ash_fear_jade"),
          material_items: [
            %{name: fetch_item_name.("bloody_fear_jade"), material_amount: 10},
            %{name: fetch_item_name.("gold_fear_jade"), material_amount: 10},
            %{name: fetch_item_name.("turquoise_fear_jade"), material_amount: 10},
            %{name: fetch_item_name.("sapphire_fear_jade"), material_amount: 10}
          ]
        }
      ]
      |> Enum.map(fn item -> Map.put_new(item, :media, "Central Forge") end),
      weaponary: [
        %{
          product_item_name: fetch_item_name.("black_lotus_cannon"),
          material_items: [
            %{name: fetch_item_name.("daejanggunpo"), material_amount: 2},
            %{name: fetch_item_name.("force_beads_flame"), material_amount: 10},
            %{name: fetch_item_name.("force_beads_wind"), material_amount: 10},
            %{name: fetch_item_name.("nightmare_seal"), material_amount: 20},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 50}
          ]
        },
        %{
          product_item_name: fetch_item_name.("bell_of_black_lotus"),
          material_items: [
            %{name: fetch_item_name.("white_lotus_marble"), material_amount: 3},
            %{name: fetch_item_name.("force_beads_water"), material_amount: 10},
            %{name: fetch_item_name.("force_beads_thunder"), material_amount: 10},
            %{name: fetch_item_name.("nightmare_seal"), material_amount: 20},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 50}
          ]
        },
        %{
          product_item_name: fetch_item_name.("white_lotus_marble"),
          material_items: [
            %{name: fetch_item_name.("jineom_marble"), material_amount: 3},
            %{name: fetch_item_name.("balo_ivory"), material_amount: 30},
            %{name: fetch_item_name.("masu_eye"), material_amount: 30},
            %{name: fetch_item_name.("quality_soul_stone_anger"), material_amount: 50},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("dragon_horn"),
          material_items: [
            %{name: fetch_item_name.("garnet"), material_amount: 1},
            %{name: fetch_item_name.("blubber_candle"), material_amount: 10},
            %{name: fetch_item_name.("paulownia_board"), material_amount: 500},
            %{name: fetch_item_name.("steel"), material_amount: 300}
          ]
        },
        %{
          product_item_name: fetch_item_name.("sky_scorcher"),
          material_items: [
            %{name: fetch_item_name.("blue_moon_dragon"), material_amount: 3},
            %{name: fetch_item_name.("chow_horns"), material_amount: 5},
            %{name: fetch_item_name.("witch_stick"), material_amount: 50},
            %{name: fetch_item_name.("stone_essence"), material_amount: 30},
            %{name: fetch_item_name.("soul_stone_anger"), material_amount: 50}
          ]
        },
        %{
          product_item_name: fetch_item_name.("frozen_needle"),
          material_items: [
            %{name: fetch_item_name.("gourd_bottle_of_evil_thoughts"), material_amount: 10},
            %{name: fetch_item_name.("jawoonbi_jade"), material_amount: 30},
            %{name: fetch_item_name.("dazzleweed"), material_amount: 20},
            %{name: fetch_item_name.("silver"), material_amount: 300}
          ]
        },
        %{
          product_item_name: fetch_item_name.("jumong_bow"),
          material_items: [
            %{name: fetch_item_name.("seeds_of_the_sacred_tree"), material_amount: 50},
            %{name: fetch_item_name.("phantom_elephant_ivory"), material_amount: 200},
            %{name: fetch_item_name.("xiaoling_hairpin"), material_amount: 8},
            %{name: fetch_item_name.("cracked_arrowhead"), material_amount: 100},
            %{name: fetch_item_name.("flame_embers"), material_amount: 300}
          ]
        },
        %{
          product_item_name: fetch_item_name.("golden_hook"),
          material_items: [
            %{name: fetch_item_name.("demon_slayer"), material_amount: 3},
            %{name: fetch_item_name.("soul_crystal"), material_amount: 30},
            %{name: fetch_item_name.("san_magic_stone"), material_amount: 50},
            %{name: fetch_item_name.("copper"), material_amount: 1000},
            %{name: fetch_item_name.("medal_of_honor"), material_amount: 300}
          ]
        },
        %{
          product_item_name: fetch_item_name.("taowu_fang"),
          material_items: [
            %{name: fetch_item_name.("taowu_giant_fang"), material_amount: 40},
            %{name: fetch_item_name.("crystal_of_water"), material_amount: 40},
            %{name: fetch_item_name.("soul_crystal"), material_amount: 20},
            %{name: fetch_item_name.("black_crystal"), material_amount: 20},
            %{name: fetch_item_name.("essence_of_abyss"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("taoties_horn"),
          material_items: [
            %{name: fetch_item_name.("taotie_shoulder_horn"), material_amount: 40},
            %{name: fetch_item_name.("crystal_of_flame"), material_amount: 40},
            %{name: fetch_item_name.("soul_crystal"), material_amount: 20},
            %{name: fetch_item_name.("horns_of_a_sentinel"), material_amount: 40},
            %{name: fetch_item_name.("essence_of_abyss"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("qiong_qi_feather"),
          material_items: [
            %{name: fetch_item_name.("qiong_qi_feather_fragment"), material_amount: 40},
            %{name: fetch_item_name.("crystal_of_wind"), material_amount: 40},
            %{name: fetch_item_name.("soul_crystal"), material_amount: 20},
            %{name: fetch_item_name.("dark_crystal"), material_amount: 20},
            %{name: fetch_item_name.("essence_of_abyss"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("hundun_needle"),
          material_items: [
            %{name: fetch_item_name.("hundun_needle_tip"), material_amount: 40},
            %{name: fetch_item_name.("crystal_of_earth"), material_amount: 40},
            %{name: fetch_item_name.("soul_crystal"), material_amount: 20},
            %{name: fetch_item_name.("thorn_root"), material_amount: 40},
            %{name: fetch_item_name.("essence_of_abyss"), material_amount: 10}
          ]
        }
      ]
      |> Enum.map(fn item -> Map.put_new(item, :media, "Weaponary") end),
      armory: [
        %{
          product_item_name: fetch_item_name.("amaterasu_crown"),
          material_items: [
            %{name: fetch_item_name.("amaterasu_helmet_diagram"), material_amount: 1},
            %{name: fetch_item_name.("spirit_helmet"), material_amount: 2},
            %{name: fetch_item_name.("jadebelt_of_a_mysteriousforce"), material_amount: 30},
            %{name: fetch_item_name.("ancient_yeti_horn"), material_amount: 30},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 50}
          ]
        },
        %{
          product_item_name: fetch_item_name.("amaterasu_armor"),
          material_items: [
            %{name: fetch_item_name.("amaterasu_armor_diagram"), material_amount: 1},
            %{name: fetch_item_name.("spirit_armor"), material_amount: 2},
            %{name: fetch_item_name.("blue_silk_with_mysterious_power"), material_amount: 30},
            %{name: fetch_item_name.("ancient_yeti_floccus"), material_amount: 30},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 50}
          ]
        },
        %{
          product_item_name: fetch_item_name.("wons_glove"),
          material_items: [
            %{name: fetch_item_name.("yellow_dragons_scale"), material_amount: 1},
            %{name: fetch_item_name.("hard_covering"), material_amount: 30},
            %{name: fetch_item_name.("cow_leather"), material_amount: 50},
            %{name: fetch_item_name.("jade"), material_amount: 150}
          ]
        }
      ]
      |> Enum.map(fn item -> Map.put_new(item, :media, "Armory") end),
      factory: [
        %{
          product_item_name: fetch_item_name.("advanced_taowu_fang"),
          material_items: [
            %{name: fetch_item_name.("taowu_fang"), material_amount: 1},
            %{name: fetch_item_name.("black_crystal"), material_amount: 20},
            %{name: fetch_item_name.("crystal_of_water"), material_amount: 20},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 20},
            %{name: fetch_item_name.("perils_soul"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("advanced_taoties_horn"),
          material_items: [
            %{name: fetch_item_name.("taoties_horn"), material_amount: 1},
            %{name: fetch_item_name.("horns_of_a_sentinel"), material_amount: 20},
            %{name: fetch_item_name.("crystal_of_flame"), material_amount: 20},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 20},
            %{name: fetch_item_name.("perils_soul"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("advanced_qiong_qi_feather"),
          material_items: [
            %{name: fetch_item_name.("qiong_qi_feather"), material_amount: 1},
            %{name: fetch_item_name.("dark_crystal"), material_amount: 20},
            %{name: fetch_item_name.("crystal_of_wind"), material_amount: 20},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 20},
            %{name: fetch_item_name.("perils_soul"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("advanced_hundun_needle"),
          material_items: [
            %{name: fetch_item_name.("hundun_needle"), material_amount: 1},
            %{name: fetch_item_name.("thorn_root"), material_amount: 20},
            %{name: fetch_item_name.("crystal_of_earth"), material_amount: 20},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 20},
            %{name: fetch_item_name.("perils_soul"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("duis_ring"),
          material_items: [
            %{name: fetch_item_name.("goonmo_horn"), material_amount: 50},
            %{name: fetch_item_name.("component_seal"), material_amount: 2},
            %{name: fetch_item_name.("soul_crystal"), material_amount: 30},
            %{name: fetch_item_name.("yellow_dragons_scale"), material_amount: 50},
            %{name: fetch_item_name.("sinsu_eye"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("king_chiyou_ring"),
          material_items: [
            %{name: fetch_item_name.("zhuge_liang_ring"), material_amount: 3},
            %{name: fetch_item_name.("demon_ring"), material_amount: 3},
            %{name: fetch_item_name.("god_metal"), material_amount: 30},
            %{name: fetch_item_name.("temporal_vortex_silver_coin"), material_amount: 300},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 100}
          ]
        }
      ]
      |> Enum.map(fn item -> Map.put_new(item, :media, "Factory") end),
      alchemist: [
        %{
          product_item_name: fetch_item_name.("tranquilizer"),
          material_items: [
            %{name: fetch_item_name.("blue_powder"), material_amount: 20},
            %{name: fetch_item_name.("dazzleweed"), material_amount: 20},
            %{name: fetch_item_name.("imoogis_scales"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("temporal_powder"),
          material_items: [
            %{name: fetch_item_name.("phoenix_feather"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("five_color_powder"),
          material_items: [
            %{name: fetch_item_name.("red_powder"), material_amount: 10},
            %{name: fetch_item_name.("mountain_flower"), material_amount: 10},
            %{name: fetch_item_name.("golden_lotus"), material_amount: 10},
            %{name: fetch_item_name.("seokgyun_swamp"), material_amount: 10},
            %{name: fetch_item_name.("prickly_pear"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("polish_powder"),
          material_items: [
            %{name: fetch_item_name.("blue_powder"), material_amount: 10},
            %{name: fetch_item_name.("gold_powder"), material_amount: 10},
            %{name: fetch_item_name.("white_powder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("gold_powder"),
          material_items: [
            %{name: fetch_item_name.("sedum_album"), material_amount: 10},
            %{name: fetch_item_name.("thousand_year_lake_plant"), material_amount: 1},
            %{name: fetch_item_name.("fair_essence"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("red_powder"),
          material_items: [
            %{name: fetch_item_name.("black_powder"), material_amount: 10},
            %{name: fetch_item_name.("flame_flower"), material_amount: 10},
            %{name: fetch_item_name.("solar_flower"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("black_powder"),
          material_items: [
            %{name: fetch_item_name.("sang_hwang_mushroom"), material_amount: 10},
            %{name: fetch_item_name.("windflower"), material_amount: 10},
            %{name: fetch_item_name.("kid_ginseng"), material_amount: 10},
            %{name: fetch_item_name.("essence_of_life"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("white_powder"),
          material_items: [
            %{name: fetch_item_name.("honeysuckle"), material_amount: 10},
            %{name: fetch_item_name.("wolfporia"), material_amount: 10},
            %{name: fetch_item_name.("poor_essence"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("blue_powder"),
          material_items: [
            %{name: fetch_item_name.("snow_ginseng"), material_amount: 10},
            %{name: fetch_item_name.("honeyweed"), material_amount: 10},
            %{name: fetch_item_name.("good_essence"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("sword_seal"),
          material_items: [
            %{name: fetch_item_name.("red_powder"), material_amount: 20},
            %{name: fetch_item_name.("sword_material"), material_amount: 5},
            %{name: fetch_item_name.("sword_element"), material_amount: 5},
            %{name: fetch_item_name.("essence_of_abyss"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("component_seal"),
          material_items: [
            %{name: fetch_item_name.("red_powder"), material_amount: 20},
            %{name: fetch_item_name.("component_material"), material_amount: 5},
            %{name: fetch_item_name.("component_element"), material_amount: 5},
            %{name: fetch_item_name.("essence_of_abyss"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("storage_ticket"),
          material_items: [
            %{name: fetch_item_name.("red_powder"), material_amount: 30},
            %{name: fetch_item_name.("hardened_wood"), material_amount: 10},
            %{name: fetch_item_name.("food"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("mysterious_medicine_of_life"),
          material_items: [
            %{name: fetch_item_name.("mysterious_medicine_of_death"), material_amount: 1},
            %{name: fetch_item_name.("five_color_crystal"), material_amount: 5},
            %{name: fetch_item_name.("root_of_life"), material_amount: 20},
            %{name: fetch_item_name.("essence_of_life"), material_amount: 10},
            %{name: fetch_item_name.("temporal_powder"), material_amount: 2}
          ]
        },
        %{
          product_item_name: fetch_item_name.("mana_pill_15d"),
          material_items: [
            %{name: fetch_item_name.("five_color_powder"), material_amount: 10},
            %{name: fetch_item_name.("blue_powder"), material_amount: 10},
            %{name: fetch_item_name.("mana_pill_1d"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("devil_wing_1day"),
          material_items: [
            %{name: fetch_item_name.("five_color_powder"), material_amount: 10},
            %{name: fetch_item_name.("seokgyun_swamp"), material_amount: 10},
            %{name: fetch_item_name.("food"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("immortality"),
          material_items: [
            %{name: fetch_item_name.("red_powder"), material_amount: 5},
            %{name: fetch_item_name.("nine_leafed_plant"), material_amount: 10},
            %{name: fetch_item_name.("food"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("wandering_artists_phrase"),
          material_items: [
            %{name: fetch_item_name.("black_powder"), material_amount: 10},
            %{name: fetch_item_name.("yellow_dragons_scale"), material_amount: 2},
            %{name: fetch_item_name.("trigram_cloth"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("the_art_of_war_vol_24"),
          material_items: [
            %{name: fetch_item_name.("wandering_artists_phrase"), material_amount: 1},
            %{name: fetch_item_name.("food"), material_amount: 5}
          ]
        }
      ]
      |> Enum.map(fn item -> Map.put_new(item, :media, "Alchemist") end),
      metallurgist: [
        %{
          product_item_name: fetch_item_name.("bloodstone"),
          material_items: [
            %{name: fetch_item_name.("spirit_gem"), material_amount: 5},
            %{name: fetch_item_name.("corundum"), material_amount: 5},
            %{name: fetch_item_name.("red_powder"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("obsidian"),
          material_items: [
            %{name: fetch_item_name.("graphite"), material_amount: 5},
            %{name: fetch_item_name.("black_ice_stone"), material_amount: 5},
            %{name: fetch_item_name.("black_powder"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("fisheye"),
          material_items: [
            %{name: fetch_item_name.("beryl"), material_amount: 10},
            %{name: fetch_item_name.("jadeite"), material_amount: 10},
            %{name: fetch_item_name.("blue_powder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("goldstone"),
          material_items: [
            %{name: fetch_item_name.("garnet"), material_amount: 10},
            %{name: fetch_item_name.("thousand_year_rock"), material_amount: 10},
            %{name: fetch_item_name.("gold_powder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("white_crystal"),
          material_items: [
            %{name: fetch_item_name.("clear_crystal"), material_amount: 10},
            %{name: fetch_item_name.("marble"), material_amount: 10},
            %{name: fetch_item_name.("white_powder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("carved_fisheye"),
          material_items: [
            %{name: fetch_item_name.("fisheye"), material_amount: 5},
            %{name: fetch_item_name.("blue_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("carved_bloodstone"),
          material_items: [
            %{name: fetch_item_name.("bloodstone"), material_amount: 5},
            %{name: fetch_item_name.("red_powder"), material_amount: 5},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("carved_obsidian"),
          material_items: [
            %{name: fetch_item_name.("obsidian"), material_amount: 5},
            %{name: fetch_item_name.("black_powder"), material_amount: 5},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("carved_goldstone"),
          material_items: [
            %{name: fetch_item_name.("goldstone"), material_amount: 5},
            %{name: fetch_item_name.("gold_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("carved_white_crystal"),
          material_items: [
            %{name: fetch_item_name.("white_crystal"), material_amount: 5},
            %{name: fetch_item_name.("white_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("powered_bloodstone"),
          material_items: [
            %{name: fetch_item_name.("carved_bloodstone"), material_amount: 5},
            %{name: fetch_item_name.("red_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1},
            %{name: fetch_item_name.("crystal_of_flame"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("powered_obsidian"),
          material_items: [
            %{name: fetch_item_name.("carved_obsidian"), material_amount: 5},
            %{name: fetch_item_name.("black_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1},
            %{name: fetch_item_name.("crystal_of_earth"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("powered_fisheye"),
          material_items: [
            %{name: fetch_item_name.("carved_fisheye"), material_amount: 5},
            %{name: fetch_item_name.("blue_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1},
            %{name: fetch_item_name.("crystal_of_water"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("powered_goldstone"),
          material_items: [
            %{name: fetch_item_name.("carved_goldstone"), material_amount: 5},
            %{name: fetch_item_name.("gold_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1},
            %{name: fetch_item_name.("crystal_of_wind"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("powered_white_crystal"),
          material_items: [
            %{name: fetch_item_name.("carved_white_crystal"), material_amount: 5},
            %{name: fetch_item_name.("white_powder"), material_amount: 10},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1},
            %{name: fetch_item_name.("crystal_of_thunder"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("soul_crystal"),
          material_items: [
            %{name: fetch_item_name.("soul_of_fey_creature"), material_amount: 3},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1}
          ]
        },
        %{
          product_item_name: fetch_item_name.("amethyst_ring"),
          material_items: [
            %{name: fetch_item_name.("purple_gem"), material_amount: 10},
            %{name: fetch_item_name.("jade"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("zhuge_liang_ring"),
          material_items: [
            %{name: fetch_item_name.("powered_bloodstone"), material_amount: 3},
            %{name: fetch_item_name.("yellow_dragons_scale"), material_amount: 10},
            %{name: fetch_item_name.("flame_dragon_embers"), material_amount: 10},
            %{name: fetch_item_name.("diamond"), material_amount: 100},
            %{name: fetch_item_name.("polish_powder"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("demon_ring"),
          material_items: [
            %{name: fetch_item_name.("powered_white_crystal"), material_amount: 2},
            %{name: fetch_item_name.("powered_obsidian"), material_amount: 2},
            %{name: fetch_item_name.("cracked_jade_ring"), material_amount: 30},
            %{name: fetch_item_name.("red_crystal"), material_amount: 30},
            %{name: fetch_item_name.("polish_powder"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("yellow_dragons_needle"),
          material_items: [
            %{name: fetch_item_name.("frozen_needle"), material_amount: 1},
            %{name: fetch_item_name.("bisa_horn"), material_amount: 20},
            %{name: fetch_item_name.("hornets_needle"), material_amount: 10},
            %{name: fetch_item_name.("powered_goldstone"), material_amount: 10},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("five_color_crystal"),
          material_items: [
            %{name: fetch_item_name.("five_color_crystal_powder_fragment"), material_amount: 10},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 2},
            %{name: fetch_item_name.("tranquilizer"), material_amount: 1},
            %{name: fetch_item_name.("polish_powder"), material_amount: 40}
          ]
        }
      ]
      |> Enum.map(fn item -> Map.put_new(item, :media, "Metallurgist") end),
      blacksmith: [
        %{
          product_item_name: fetch_item_name.("brass"),
          material_items: [
            %{name: fetch_item_name.("copper"), material_amount: 30},
            %{name: fetch_item_name.("zinc"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("bronze"),
          material_items: [
            %{name: fetch_item_name.("copper"), material_amount: 30},
            %{name: fetch_item_name.("tin"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("iron_bar"),
          material_items: [
            %{name: fetch_item_name.("coal"), material_amount: 30},
            %{name: fetch_item_name.("steel"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("dark_iron_bar"),
          material_items: [
            %{name: fetch_item_name.("iron_bar"), material_amount: 20},
            %{name: fetch_item_name.("graphite"), material_amount: 20},
            %{name: fetch_item_name.("limestone"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("black_steel_ingot"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 10},
            %{name: fetch_item_name.("cold_steel"), material_amount: 10},
            %{name: fetch_item_name.("iron_ore"), material_amount: 10},
            %{name: fetch_item_name.("ironwood"), material_amount: 10}
          ]
        },
        %{
          product_item_name: fetch_item_name.("iron_clamp"),
          material_items: [
            %{name: fetch_item_name.("iron_bar"), material_amount: 30},
            %{name: fetch_item_name.("flame_dragon_embers"), material_amount: 1},
            %{name: fetch_item_name.("bronze"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("shining_iron_clamp"),
          material_items: [
            %{name: fetch_item_name.("iron_clamp"), material_amount: 1},
            %{name: fetch_item_name.("black_steel_ingot"), material_amount: 20},
            %{name: fetch_item_name.("rainbow_stone"), material_amount: 20},
            %{name: fetch_item_name.("five_color_powder"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("yeraes_pickax"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 50},
            %{name: fetch_item_name.("white_gold"), material_amount: 50},
            %{name: fetch_item_name.("silver"), material_amount: 300}
          ]
        },
        %{
          product_item_name: fetch_item_name.("hanchaes_hoe"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 50},
            %{name: fetch_item_name.("red_iron_stone"), material_amount: 50},
            %{name: fetch_item_name.("gold"), material_amount: 300}
          ]
        },
        %{
          product_item_name: fetch_item_name.("blue_moon_dragon"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 100},
            %{name: fetch_item_name.("yellow_dragons_scale"), material_amount: 3},
            %{name: fetch_item_name.("sword_seal"), material_amount: 1},
            %{name: fetch_item_name.("spirit_gem"), material_amount: 100},
            %{name: fetch_item_name.("crystal_of_thunder"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("demon_slayer"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 100},
            %{name: fetch_item_name.("flame_dragon_embers"), material_amount: 3},
            %{name: fetch_item_name.("sword_seal"), material_amount: 1},
            %{name: fetch_item_name.("red_iron_stone"), material_amount: 100},
            %{name: fetch_item_name.("crystal_of_earth"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("jaryong"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 500},
            %{name: fetch_item_name.("diamond"), material_amount: 30},
            %{name: fetch_item_name.("black_crystal"), material_amount: 20},
            %{name: fetch_item_name.("crystal_of_flame"), material_amount: 50},
            %{name: fetch_item_name.("crystal_of_water"), material_amount: 50}
          ]
        },
        %{
          product_item_name: fetch_item_name.("duis_helmet"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 300},
            %{name: fetch_item_name.("powered_fisheye"), material_amount: 2},
            %{name: fetch_item_name.("blue_crystal"), material_amount: 50},
            %{name: fetch_item_name.("north_sea_ice_crystal"), material_amount: 30},
            %{name: fetch_item_name.("horns_of_a_sentinel"), material_amount: 30}
          ]
        },
        %{
          product_item_name: fetch_item_name.("duis_armor"),
          material_items: [
            %{name: fetch_item_name.("dark_iron_bar"), material_amount: 500},
            %{name: fetch_item_name.("powered_fisheye"), material_amount: 4},
            %{name: fetch_item_name.("black_crystal"), material_amount: 20},
            %{name: fetch_item_name.("water_essence"), material_amount: 20},
            %{name: fetch_item_name.("essence_of_abyss"), material_amount: 5}
          ]
        },
        %{
          product_item_name: fetch_item_name.("spirit_gloves"),
          material_items: [
            %{name: fetch_item_name.("black_steel_ingot"), material_amount: 100},
            %{name: fetch_item_name.("topaz"), material_amount: 100},
            %{name: fetch_item_name.("masu_corrupted_soul"), material_amount: 50},
            %{name: fetch_item_name.("skeleton_piece_4"), material_amount: 20},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 20}
          ]
        },
        %{
          product_item_name: fetch_item_name.("daejanggunpo"),
          material_items: [
            %{name: fetch_item_name.("dragon_horn"), material_amount: 1},
            %{name: fetch_item_name.("omuns_cannon_fragment"), material_amount: 5},
            %{name: fetch_item_name.("piece_of_the_sun"), material_amount: 10},
            %{name: fetch_item_name.("black_steel_ingot"), material_amount: 100},
            %{name: fetch_item_name.("sealed_power_shard"), material_amount: 20}
          ]
        }
      ]
      |> Enum.map(fn item -> Map.put_new(item, :media, "Blacksmith") end)
    }
  end

  def list_recipes do
    recipe_dictionary()
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

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

product_materials = [
  %{product: "Sealed Power Shard", materials: ["Sealed Power Piece"]},
  %{product: "Sealed Power Shard", materials: ["Yellow Force Stone", "Red Force Stone", "Blue Force Stone"]},
]

Data.Dictionary.Items.list_items()
|> Enum.map(fn {item_key, attr} ->
  GersangDb.GersangItem.create_item(attr)
end)

Data.Dictionary.RecipeSpecs.list_recipe_specs()
|> Enum.map(fn %{product_name: name} = params ->
  product_item = GersangDb.GersangItem.get_item_by_name(name)

  if is_nil(product_item) do
    raise "Product item not found for recipe spec: #{name}"
  end

  attr = Map.put(params, :product_item_id, product_item.id)

  GersangDb.RecipeSpecs.create_recipe_spec(attr)
end)

Data.Dictionary.Recipes.list_recipes()
|> Enum.map(fn %{product_item_name: product_name, material_items: material_items, media: media} = params ->
  product_item = GersangDb.GersangItem.get_item_by_name(product_name)

  if is_nil(product_item) do
    raise "Product item not found for recipe: #{product_name}"
  end

  recipe_spec = GersangDb.RecipeSpecs.get_recipe_spec_by_product_and_media(product_item.id, media)

  if is_nil(recipe_spec) do
    raise "Recipe spec not found for product: #{product_name}, media: #{media}"
  end

  material_items
  |> Enum.each(fn %{name: material_name, material_amount: material_amount} ->
    amterial_item = GersangDb.GersangItem.get_item_by_name(material_name)

    if is_nil(amterial_item) do
      raise "Material item not found for recipe: #{product_name}, material: #{material_name}"
    else
      attr = %{
        product_item_id: product_item.id,
        material_item_id: amterial_item.id,
        material_amount: material_amount,
        recipe_spec_id: recipe_spec.id,
      }

      GersangDb.Gersang.Recipes.create_recipe(attr)
    end
  end)
end)

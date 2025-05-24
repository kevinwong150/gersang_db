defmodule GersangDb.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :product_item_id, references(:gersang_items, on_delete: :nothing), null: false
      add :material_item_id, references(:gersang_items, on_delete: :nothing), null: false
      add :media, :string


      timestamps()
    end

    create unique_index(:recipes, [:product_item_id, :material_item_id])
  end
end

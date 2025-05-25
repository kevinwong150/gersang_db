defmodule GersangDb.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :product_item_id, references(:gersang_items), null: false
      add :material_item_id, references(:gersang_items), null: false
      add :media, :string


      timestamps()
    end
  end
end

defmodule GersangDb.Repo.Migrations.CreateRecipeSpec do
  use Ecto.Migration

  def change do
    create table(:recipe_spec) do
      add :product_item_id, references(:gersang_items, on_delete: :delete_all), null: false
      add :production_fee, :integer, default: 0
      add :production_amount, :integer, default: 1
      add :wages, :integer, default: 1000
      add :workload, :integer, default: 0
      add :media, :string, null: false

      timestamps()
    end

    create index(:recipe_spec, [:product_item_id])
  end
end

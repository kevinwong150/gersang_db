defmodule GersangDb.Repo.Migrations.CreateGersangItems do
  use Ecto.Migration

  def change do
    create table(:gersang_items) do
      add :name, :string, null: false
      add :tags, {:array, :string}
      add :margin, :float
      add :market_price,  :bigint
      add :cost_per, :float
      add :artisan_product?, :boolean, null: false, default: false
      add :artisan_production_amount, :integer
      add :artisan_production_fee, :integer

      timestamps()
    end
  end
end

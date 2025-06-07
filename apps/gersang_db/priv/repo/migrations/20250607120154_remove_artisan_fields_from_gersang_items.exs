defmodule GersangDb.Repo.Migrations.RemoveArtisanFieldsFromGersangItems do
  use Ecto.Migration

  def change do
    alter table(:gersang_items) do
      remove :artisan_product?, :boolean
      remove :artisan_production_amount, :integer
      remove :artisan_production_fee, :integer
    end
  end
end

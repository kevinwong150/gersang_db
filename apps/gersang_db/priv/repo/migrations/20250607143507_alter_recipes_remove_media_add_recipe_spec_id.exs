defmodule GersangDb.Repo.Migrations.AlterRecipesRemoveMediaAddRecipeSpecId do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      remove :media
      add :recipe_spec_id, references(:recipe_spec, on_delete: :delete_all)
    end
  end
end

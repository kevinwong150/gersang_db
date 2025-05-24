defmodule GersangDb.Domain.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias GersangDb.Domain.GersangItem

  schema "recipes" do
    field :media, :string

    belongs_to :product_item, GersangItem, foreign_key: :product_item_id
    belongs_to :material_item, GersangItem, foreign_key: :material_item_id

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:media, :product_item_id, :material_item_id])
    |> validate_required([:product_item_id, :material_item_id])
    |> foreign_key_constraint(:product_item_id)
    |> foreign_key_constraint(:material_item_id)
    |> unique_constraint([:product_item_id, :material_item_id], name: :recipes_product_item_id_material_item_id_index)
  end
end

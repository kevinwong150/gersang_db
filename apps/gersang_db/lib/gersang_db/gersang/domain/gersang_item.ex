defmodule GersangDb.Domain.GersangItem do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias GersangDb.Domain.Recipe
  schema "gersang_items" do
    field(:name, :string)
    field(:tags, {:array, :string})
    field(:margin, :float)
    field(:market_price, :integer)
    field(:cost_per, :float)

    has_many :recipes_as_product, Recipe, foreign_key: :product_item_id
    has_many :recipes_as_material, Recipe, foreign_key: :material_item_id

    # New associations for direct access to materials and products
    has_many :materials, through: [:recipes_as_product, :material_item]
    has_many :products, through: [:recipes_as_material, :product_item]

    timestamps()
  end
  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :name,
      :tags,
      :margin,
      :market_price,
      :cost_per
    ])
    |> validate_required([:name])
  end
end

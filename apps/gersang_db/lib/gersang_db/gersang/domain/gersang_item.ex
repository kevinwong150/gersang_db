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
    field(:artisan_product?, :boolean, default: false)
    field(:artisan_production_amount, :integer)
    field(:artisan_production_fee, :integer)

    has_many :recipes_as_product, Recipe, foreign_key: :product_item_id
    has_many :recipes_as_material, Recipe, foreign_key: :material_item_id

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
      :cost_per,
      :artisan_product?,
      :artisan_production_amount,
      :artisan_production_fee
    ])
    |> validate_required([:name, :artisan_product?])
  end
end

defmodule GersangDb.Domain.GersangItem do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "gersang_items" do
    field(:name, :string)
    field(:tags, {:array, :string})
    field(:margin, :float)
    field(:market_price, :integer)
    field(:cost_per, :float)
    field(:artisan_product?, :boolean, default: false)
    field(:artisan_production_amount, :integer)
    field(:artisan_production_fee, :integer)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
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

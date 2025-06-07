defmodule GersangDb.Domain.RecipeSpec do
  use Ecto.Schema
  import Ecto.Changeset

  alias GersangDb.Domain.GersangItem

  schema "recipe_spec" do
    field :production_fee, :integer, default: 0
    field :production_amount, :integer, default: 1
    field :wages, :integer, default: 1000
    field :workload, :integer, default: 0
    field :media, :string

    belongs_to :product_item, GersangItem

    timestamps()
  end

  @doc false
  def changeset(recipe_spec, attrs) do
    recipe_spec
    |> cast(attrs, [:production_fee, :production_amount, :wages, :workload, :media, :product_item_id])
    |> validate_required([:production_fee, :production_amount, :wages, :workload, :media, :product_item_id])
    |> foreign_key_constraint(:product_item_id)
  end
end

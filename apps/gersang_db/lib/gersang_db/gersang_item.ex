defmodule GersangDb.GersangItem do
  @moduledoc """
  The GersangItem context.
  """

  import Ecto.Query, warn: false
  alias GersangDb.Repo

  alias GersangDb.Domain.GersangItem

  @doc """
  Returns the list of gersang_items.

  ## Examples

      iex> list_items()
      [%GersangItem{}, ...]

  """
  def list_items do
    Repo.all(GersangItem)
  end

  @doc """
  Gets a single gersang_item.

  Raises `Ecto.NoResultsError` if the Gersang item does not exist.

  ## Examples

      iex> get_item!(123)
      %GersangItem{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(GersangItem, id)

  @doc """
  Gets a single gersang_item by its name.

  Returns `nil` if the Gersang item does not exist.

  ## Examples

      iex> get_item_by_name("Sealed Power Piece")
      %GersangItem{}

      iex> get_item_by_name("Non Existent Item")
      nil
  """
  def get_item_by_name(name) do
    Repo.get_by(GersangItem, name: name)
  end

  @doc """
  Creates a gersang_item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %GersangItem{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %GersangItem{}
    |> GersangItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gersang_item.

  ## Examples

      iex> update_item(gersang_item, %{field: new_value})
      {:ok, %GersangItem{}}

      iex> update_item(gersang_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%GersangItem{} = gersang_item, attrs) do
    gersang_item
    |> GersangItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gersang_item.

  ## Examples

      iex> delete_item(gersang_item)
      {:ok, %GersangItem{}}

      iex> delete_item(gersang_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%GersangItem{} = gersang_item) do
    Repo.delete(gersang_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gersang_item changes.

  ## Examples

      iex> change_item(gersang_item)
      %Ecto.Changeset{data: %GersangItem{}}

  """
  def change_item(%GersangItem{} = gersang_item, attrs \\ %{}) do
    GersangItem.changeset(gersang_item, attrs)
  end

  def preload_material(%{materials: []} = gersang_item) do
    gersang_item
  end

  def preload_material(gersang_item) do
    gersang_item
    |> Repo.preload([:materials, recipes_as_product: :recipe_spec])
    |> then(fn item ->
      item
      |> Map.put(:materials, Enum.map(item.materials, &preload_material(&1)))
    end)
  end
end

defmodule GersangDb.GersangItems do
  @moduledoc """
  The GersangItems context.
  """

  import Ecto.Query, warn: false
  alias GersangDb.Repo

  alias GersangDb.Domain.GersangItems

  @doc """
  Returns the list of gersang_items.

  ## Examples

      iex> list_items()
      [%GersangItem{}, ...]

  """
  def list_items do
    Repo.all(GersangItems)
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
  def get_item!(id), do: Repo.get!(GersangItems, id)

  @doc """
  Creates a gersang_item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %GersangItems{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %GersangItems{}
    |> GersangItems.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gersang_item.

  ## Examples

      iex> update_item(gersang_item, %{field: new_value})
      {:ok, %GersangItems{}}

      iex> update_item(gersang_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%GersangItems{} = gersang_item, attrs) do
    gersang_item
    |> GersangItems.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gersang_item.

  ## Examples

      iex> delete_item(gersang_item)
      {:ok, %GersangItems{}}

      iex> delete_item(gersang_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%GersangItems{} = gersang_item) do
    Repo.delete(gersang_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gersang_item changes.

  ## Examples

      iex> change_item(gersang_item)
      %Ecto.Changeset{data: %GersangItems{}}

  """
  def change_item(%GersangItems{} = gersang_item, attrs \\ %{}) do
    GersangItems.changeset(gersang_item, attrs)
  end
end

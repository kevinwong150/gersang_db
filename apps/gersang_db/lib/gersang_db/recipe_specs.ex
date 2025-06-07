defmodule GersangDb.RecipeSpecs do
  @moduledoc """
  The RecipeSpecs context.
  """

  import Ecto.Query, warn: false
  alias GersangDb.Repo
  alias GersangDb.Domain.RecipeSpec

  @doc """
  Returns the list of recipe_specs.

  ## Examples

      iex> list_recipe_specs()
      [%RecipeSpec{}, ...]

  """
  def list_recipe_specs do
    Repo.all(from r in RecipeSpec, preload: [:product_item])
  end

  @doc """
  Gets a single recipe_spec.

  Raises `Ecto.NoResultsError` if the Recipe spec does not exist.

  ## Examples

      iex> get_recipe_spec!(123)
      %RecipeSpec{}

      iex> get_recipe_spec!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe_spec!(id), do: Repo.get!(RecipeSpec, id) |> Repo.preload([:product_item])

  @doc """
  Creates a recipe_spec.

  ## Examples

      iex> create_recipe_spec(%{field: value})
      {:ok, %RecipeSpec{}}

      iex> create_recipe_spec(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe_spec(attrs \\ %{}) do
    %RecipeSpec{}
    |> RecipeSpec.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe_spec.

  ## Examples

      iex> update_recipe_spec(recipe_spec, %{field: new_value})
      {:ok, %RecipeSpec{}}

      iex> update_recipe_spec(recipe_spec, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe_spec(%RecipeSpec{} = recipe_spec, attrs) do
    recipe_spec
    |> RecipeSpec.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe_spec.

  ## Examples

      iex> delete_recipe_spec(recipe_spec)
      {:ok, %RecipeSpec{}}

      iex> delete_recipe_spec(recipe_spec)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe_spec(%RecipeSpec{} = recipe_spec) do
    Repo.delete(recipe_spec)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe_spec changes.

  ## Examples

      iex> change_recipe_spec(recipe_spec)
      %Ecto.Changeset{data: %RecipeSpec{}}

  """
  def change_recipe_spec(%RecipeSpec{} = recipe_spec, attrs \\ %{}) do
    RecipeSpec.changeset(recipe_spec, attrs)
  end

  @doc """
  Gets a recipe_spec by product_item_id and media.

  Returns nil if no recipe spec is found.

  ## Examples

      iex> get_recipe_spec_by_product_and_media(123, "Blacksmith")
      %RecipeSpec{}

      iex> get_recipe_spec_by_product_and_media(456, "Blacksmith")
      nil

  """
  def get_recipe_spec_by_product_and_media(product_item_id, media) do
    Repo.one(from r in RecipeSpec, where: r.product_item_id == ^product_item_id and r.media == ^media, preload: [:product_item])
  end

  @doc """
  Gets a recipe_spec by product_item_id and media.

  Raises `Ecto.NoResultsError` if the Recipe spec does not exist.

  ## Examples

      iex> get_recipe_spec_by_product_and_media!(123, "Blacksmith")
      %RecipeSpec{}

      iex> get_recipe_spec_by_product_and_media!(456, "Blacksmith")
      ** (Ecto.NoResultsError)

  """
  def get_recipe_spec_by_product_and_media!(product_item_id, media) do
    Repo.one!(from r in RecipeSpec, where: r.product_item_id == ^product_item_id and r.media == ^media, preload: [:product_item])
  end
end

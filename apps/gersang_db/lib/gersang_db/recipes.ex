defmodule GersangDb.Gersang.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias GersangDb.Repo
  alias GersangDb.Domain.Recipe

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
    [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(from r in Recipe, preload: [:product_item, :material_item, :recipe_spec])
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)
  @doc """
  Gets a recipe by product_id and recipe_spec_id.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe_by_product_and_recipe_spec!(123, 456)
      %Recipe{}

      iex> get_recipe_by_product_and_recipe_spec!(123, 789)
      ** (Ecto.NoResultsError)

  """
  def get_recipe_by_product_and_recipe_spec!(product_id, recipe_spec_id) do
    Repo.one!(from r in Recipe, where: r.product_item_id == ^product_id and r.recipe_spec_id == ^recipe_spec_id, preload: [:product_item, :material_item, :recipe_spec])
  end

  @doc """
  Gets all recipes by product_id and recipe_spec_id.

  ## Examples

      iex> list_recipes_by_product_and_recipe_spec(123, 456)
      [%Recipe{}, ...]

  """
  def list_recipes_by_product_and_recipe_spec(product_id, recipe_spec_id) do
    Repo.all(from r in Recipe, where: r.product_item_id == ^product_id and r.recipe_spec_id == ^recipe_spec_id, preload: [:product_item, :material_item, :recipe_spec])
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end
end

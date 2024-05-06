defmodule GersangDb.GersangItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GersangDb.GersangItems` context.
  """

  @doc """
  Generate a gersang_item.
  """
  def gersang_item_fixture(attrs \\ %{}) do
    {:ok, gersang_item} =
      attrs
      |> Enum.into(%{

      })
      |> GersangDb.GersangItems.create_item()

    gersang_item
  end
end

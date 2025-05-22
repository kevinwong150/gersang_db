defmodule GersangDb.GersangItemFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GersangDb.GersangItem` context.
  """

  @doc """
  Generate a gersang_item.
  """
  def gersang_item_fixture(attrs \\ %{}) do
    {:ok, gersang_item} =
      attrs
      |> Enum.into(%{

      })
      |> GersangDb.GersangItem.create_item()

    gersang_item
  end
end

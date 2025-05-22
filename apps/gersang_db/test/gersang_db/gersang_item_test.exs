defmodule GersangDb.GersangItemTest do
  use GersangDb.DataCase

  alias GersangDb.GersangItem

  describe "gersang_items" do
    alias GersangDb.GersangItem

    import GersangDb.GersangItemFixtures

    @invalid_attrs %{}

    test "list_gersang_items/0 returns all gersang_items" do
      gersang_item = gersang_item_fixture()
      assert GersangItem.list_items() == [gersang_item]
    end

    test "get_gersang_item!/1 returns the gersang_item with given id" do
      gersang_item = gersang_item_fixture()
      assert GersangItem.get_item!(gersang_item.id) == gersang_item
    end

    test "create_gersang_item/1 with valid data creates a gersang_item" do
      valid_attrs = %{}
      assert {:ok, %GersangItem{} = gersang_item} = GersangItem.create_item(valid_attrs)
    end

    test "create_gersang_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GersangItem.create_item(@invalid_attrs)
    end

    test "update_gersang_item/2 with valid data updates the gersang_item" do
      gersang_item = gersang_item_fixture()
      update_attrs = %{}
      assert {:ok, %GersangItem{} = gersang_item} = GersangItem.update_item(gersang_item, update_attrs)
    end

    test "update_gersang_item/2 with invalid data returns error changeset" do
      gersang_item = gersang_item_fixture()
      assert {:error, %Ecto.Changeset{}} = GersangItem.update_item(gersang_item, @invalid_attrs)
      assert gersang_item == GersangItem.get_item!(gersang_item.id)
    end

    test "delete_gersang_item/1 deletes the gersang_item" do
      gersang_item = gersang_item_fixture()
      assert {:ok, %GersangItem{}} = GersangItem.delete_item(gersang_item)
      assert_raise Ecto.NoResultsError, fn -> GersangItem.get_item!(gersang_item.id) end
    end

    test "change_gersang_item/1 returns a gersang_item changeset" do
      gersang_item = gersang_item_fixture()
      assert %Ecto.Changeset{} = GersangItem.change_item(gersang_item)
    end
  end
end

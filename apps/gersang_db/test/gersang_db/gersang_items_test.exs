defmodule GersangDb.GersangItemsTest do
  use GersangDb.DataCase

  alias GersangDb.GersangItems

  describe "gersang_items" do
    alias GersangDb.GersangItems

    import GersangDb.GersangItemsFixtures

    @invalid_attrs %{}

    test "list_gersang_items/0 returns all gersang_items" do
      gersang_item = gersang_item_fixture()
      assert GersangItems.list_gersang_items() == [gersang_item]
    end

    test "get_gersang_item!/1 returns the gersang_item with given id" do
      gersang_item = gersang_item_fixture()
      assert GersangItems.get_gersang_item!(gersang_item.id) == gersang_item
    end

    test "create_gersang_item/1 with valid data creates a gersang_item" do
      valid_attrs = %{}

      assert {:ok, %GersangItem{} = gersang_item} = GersangItems.create_gersang_item(valid_attrs)
    end

    test "create_gersang_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GersangItems.create_gersang_item(@invalid_attrs)
    end

    test "update_gersang_item/2 with valid data updates the gersang_item" do
      gersang_item = gersang_item_fixture()
      update_attrs = %{}

      assert {:ok, %GersangItem{} = gersang_item} = GersangItems.update_gersang_item(gersang_item, update_attrs)
    end

    test "update_gersang_item/2 with invalid data returns error changeset" do
      gersang_item = gersang_item_fixture()
      assert {:error, %Ecto.Changeset{}} = GersangItems.update_gersang_item(gersang_item, @invalid_attrs)
      assert gersang_item == GersangItems.get_gersang_item!(gersang_item.id)
    end

    test "delete_gersang_item/1 deletes the gersang_item" do
      gersang_item = gersang_item_fixture()
      assert {:ok, %GersangItem{}} = GersangItems.delete_gersang_item(gersang_item)
      assert_raise Ecto.NoResultsError, fn -> GersangItems.get_gersang_item!(gersang_item.id) end
    end

    test "change_gersang_item/1 returns a gersang_item changeset" do
      gersang_item = gersang_item_fixture()
      assert %Ecto.Changeset{} = GersangItems.change_gersang_item(gersang_item)
    end
  end
end

defmodule Csv.RecordsTest do
  use Csv.DataCase

  alias Csv.Records

  describe "records" do
    alias Csv.Records.Record

    import Csv.RecordsFixtures

    @invalid_attrs %{date_created: nil, description: nil, link: nil, uid: nil}

    test "list_records/0 returns all records" do
      record = record_fixture()
      assert Records.list_records() == [record]
    end

    test "get_record!/1 returns the record with given id" do
      record = record_fixture()
      assert Records.get_record!(record.id) == record
    end

    test "create_record/1 with valid data creates a record" do
      valid_attrs = %{date_created: ~N[2022-10-26 16:52:00], description: "some description", link: "some link", uid: "some uid"}

      assert {:ok, %Record{} = record} = Records.create_record(valid_attrs)
      assert record.date_created == ~N[2022-10-26 16:52:00]
      assert record.description == "some description"
      assert record.link == "some link"
      assert record.uid == "some uid"
    end

    test "create_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Records.create_record(@invalid_attrs)
    end

    test "update_record/2 with valid data updates the record" do
      record = record_fixture()
      update_attrs = %{date_created: ~N[2022-10-27 16:52:00], description: "some updated description", link: "some updated link", uid: "some updated uid"}

      assert {:ok, %Record{} = record} = Records.update_record(record, update_attrs)
      assert record.date_created == ~N[2022-10-27 16:52:00]
      assert record.description == "some updated description"
      assert record.link == "some updated link"
      assert record.uid == "some updated uid"
    end

    test "update_record/2 with invalid data returns error changeset" do
      record = record_fixture()
      assert {:error, %Ecto.Changeset{}} = Records.update_record(record, @invalid_attrs)
      assert record == Records.get_record!(record.id)
    end

    test "delete_record/1 deletes the record" do
      record = record_fixture()
      assert {:ok, %Record{}} = Records.delete_record(record)
      assert_raise Ecto.NoResultsError, fn -> Records.get_record!(record.id) end
    end

    test "change_record/1 returns a record changeset" do
      record = record_fixture()
      assert %Ecto.Changeset{} = Records.change_record(record)
    end
  end
end

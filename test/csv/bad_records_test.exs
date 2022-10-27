defmodule Csv.BadRecordsTest do
  use Csv.DataCase

  alias Csv.BadRecords

  describe "bad_records" do
    alias Csv.BadRecords.BadRecord

    import Csv.BadRecordsFixtures

    @invalid_attrs %{date_created: nil, description: nil, link: nil, uid: nil}

    test "list_bad_records/0 returns all bad_records" do
      bad_record = bad_record_fixture()
      assert BadRecords.list_bad_records() == [bad_record]
    end

    test "get_bad_record!/1 returns the bad_record with given id" do
      bad_record = bad_record_fixture()
      assert BadRecords.get_bad_record!(bad_record.id) == bad_record
    end

    test "create_bad_record/1 with valid data creates a bad_record" do
      valid_attrs = %{
        date_created: ~N[2022-10-26 16:57:00],
        description: "some description",
        link: "some link",
        uid: "some uid"
      }

      assert {:ok, %BadRecord{} = bad_record} = BadRecords.create_bad_record(valid_attrs)
      assert bad_record.date_created == ~N[2022-10-26 16:57:00]
      assert bad_record.description == "some description"
      assert bad_record.link == "some link"
      assert bad_record.uid == "some uid"
    end

    test "create_bad_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BadRecords.create_bad_record(@invalid_attrs)
    end

    test "update_bad_record/2 with valid data updates the bad_record" do
      bad_record = bad_record_fixture()

      update_attrs = %{
        date_created: ~N[2022-10-27 16:57:00],
        description: "some updated description",
        link: "some updated link",
        uid: "some updated uid"
      }

      assert {:ok, %BadRecord{} = bad_record} =
               BadRecords.update_bad_record(bad_record, update_attrs)

      assert bad_record.date_created == ~N[2022-10-27 16:57:00]
      assert bad_record.description == "some updated description"
      assert bad_record.link == "some updated link"
      assert bad_record.uid == "some updated uid"
    end

    test "update_bad_record/2 with invalid data returns error changeset" do
      bad_record = bad_record_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BadRecords.update_bad_record(bad_record, @invalid_attrs)

      assert bad_record == BadRecords.get_bad_record!(bad_record.id)
    end

    test "delete_bad_record/1 deletes the bad_record" do
      bad_record = bad_record_fixture()
      assert {:ok, %BadRecord{}} = BadRecords.delete_bad_record(bad_record)
      assert_raise Ecto.NoResultsError, fn -> BadRecords.get_bad_record!(bad_record.id) end
    end

    test "change_bad_record/1 returns a bad_record changeset" do
      bad_record = bad_record_fixture()
      assert %Ecto.Changeset{} = BadRecords.change_bad_record(bad_record)
    end
  end
end

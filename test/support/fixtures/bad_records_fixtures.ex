defmodule Csv.BadRecordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Csv.BadRecords` context.
  """

  @doc """
  Generate a bad_record.
  """
  def bad_record_fixture(attrs \\ %{}) do
    {:ok, bad_record} =
      attrs
      |> Enum.into(%{
        date_created: ~N[2022-10-26 16:57:00],
        description: "some description",
        link: "some link",
        uid: "some uid"
      })
      |> Csv.BadRecords.create_bad_record()

    bad_record
  end
end

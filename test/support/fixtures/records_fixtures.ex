defmodule Csv.RecordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Csv.Records` context.
  """

  @doc """
  Generate a unique record uid.
  """
  def unique_record_uid, do: "some uid#{System.unique_integer([:positive])}"

  @doc """
  Generate a record.
  """
  def record_fixture(attrs \\ %{}) do
    {:ok, record} =
      attrs
      |> Enum.into(%{
        date_created: ~N[2022-10-26 16:52:00],
        description: "some description",
        link: "some link",
        uid: unique_record_uid()
      })
      |> Csv.Records.create_record()

    record
  end
end

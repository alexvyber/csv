defmodule Csv.BadRecords do
  @moduledoc """
  The BadRecords context.
  """

  import Ecto.Query, warn: false
  alias Csv.Repo

  alias Csv.BadRecords.BadRecord

  @doc """
  Returns the list of bad_records.

  ## Examples

      iex> list_bad_records()
      [%BadRecord{}, ...]

  """
  def list_bad_records do
    Repo.all(BadRecord)
  end

  @doc """
  Gets a single bad_record.

  Raises `Ecto.NoResultsError` if the Bad record does not exist.

  ## Examples

      iex> get_bad_record!(123)
      %BadRecord{}

      iex> get_bad_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bad_record!(id), do: Repo.get!(BadRecord, id)

  @doc """
  Creates a bad_record.

  ## Examples

      iex> create_bad_record(%{field: value})
      {:ok, %BadRecord{}}

      iex> create_bad_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bad_record(attrs \\ %{}) do
    %BadRecord{}
    |> BadRecord.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bad_record.

  ## Examples

      iex> update_bad_record(bad_record, %{field: new_value})
      {:ok, %BadRecord{}}

      iex> update_bad_record(bad_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bad_record(%BadRecord{} = bad_record, attrs) do
    bad_record
    |> BadRecord.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bad_record.

  ## Examples

      iex> delete_bad_record(bad_record)
      {:ok, %BadRecord{}}

      iex> delete_bad_record(bad_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bad_record(%BadRecord{} = bad_record) do
    Repo.delete(bad_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bad_record changes.

  ## Examples

      iex> change_bad_record(bad_record)
      %Ecto.Changeset{data: %BadRecord{}}

  """
  def change_bad_record(%BadRecord{} = bad_record, attrs \\ %{}) do
    BadRecord.changeset(bad_record, attrs)
  end
end

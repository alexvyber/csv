defmodule Csv.Records do
  @moduledoc """
  The Records context.
  """

  import Ecto.Query, warn: false
  alias Csv.Repo

  alias Csv.Records.Record

  def get_record!(id) do
    Repo.get!(Record, id)
    |> Repo.preload([:file])
  end

  def create_record(attrs \\ %{}, file) do
    %Record{}
    |> Record.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:file, file)
    |> Repo.insert()
  end

  def list_records_by_file_id!(file_id) do
    Repo.all(from(r in Record, where: r.file_id == ^file_id, order_by: [desc: r.updated_at]))
  end

  def search_records(search_phrase) do
    # start_character = String.slice(search_phrase, 0..1)

    from(
      r in Record,
      where: ilike(r.uid, ^"#{search_phrase}%")
    )
    |> Repo.all()
  end
end

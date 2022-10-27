defmodule Csv.BadRecords.BadRecord do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bad_records" do
    field :date_created, :naive_datetime
    field :description, :string
    field :link, :string
    field :uid, :string

    timestamps()
  end

  @doc false
  def changeset(bad_record, attrs) do
    bad_record
    |> cast(attrs, [:uid, :description, :date_created, :link])
    |> validate_required([:uid, :description, :date_created, :link])
  end
end

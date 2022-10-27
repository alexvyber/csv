defmodule Csv.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :date_created, :naive_datetime
    field :description, :string
    field :link, :string
    field :uid, :string

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:uid, :description, :date_created, :link])
    |> validate_required([:uid, :date_created])
    |> unique_constraint(:uid)
  end
end

defmodule Csv.Files.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :file_name, :string
    field :file_path, :string

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:file_name, :file_path])
    |> validate_required([:file_name, :file_path])
    |> unique_constraint(:file_name)
  end
end

defmodule Csv.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :file_name, :string
      add :file_path, :string

      timestamps()
    end

    create unique_index(:files, [:file_name])
  end
end

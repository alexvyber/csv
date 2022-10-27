defmodule Csv.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      add :uid, :string
      add :description, :string
      add :date_created, :naive_datetime
      add :link, :string

      timestamps()
    end

    create unique_index(:records, [:uid])
  end
end

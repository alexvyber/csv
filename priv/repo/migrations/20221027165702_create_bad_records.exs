defmodule Csv.Repo.Migrations.CreateBadRecords do
  use Ecto.Migration

  def change do
    create table(:bad_records) do
      add :uid, :string
      add :description, :string
      add :date_created, :naive_datetime
      add :link, :string

      timestamps()
    end
  end
end

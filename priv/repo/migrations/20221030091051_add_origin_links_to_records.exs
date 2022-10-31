defmodule Csv.Repo.Migrations.AddOriginLinksToRecords do
  use Ecto.Migration

  def change do
    alter table(:records) do
      add :file_id, references(:files, on_delete: :delete_all), null: false
    end

    alter table(:bad_records) do
      add :file_Id, references(:files, on_delete: :delete_all), null: false
    end
  end
end

defmodule Csv.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :file_name, :string
      add :file_path, :string
      add :errors, :integer

      timestamps()
    end

    # create unique_index(:files, [:file_name])
    # -- I dicided that I want to allow user to have multiple files with the same name
    # -- Also we kinda don't expect to have millions of files in our db
    create unique_index(:files, [:file_path])
  end
end

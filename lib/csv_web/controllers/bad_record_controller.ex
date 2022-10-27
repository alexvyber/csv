defmodule CsvWeb.BadRecordController do
  use CsvWeb, :controller

  alias Csv.BadRecords
  alias Csv.BadRecords.BadRecord

  def index(conn, _params) do
    bad_records = BadRecords.list_bad_records()
    render(conn, "index.html", bad_records: bad_records)
  end

  def new(conn, _params) do
    changeset = BadRecords.change_bad_record(%BadRecord{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bad_record" => bad_record_params}) do
    case BadRecords.create_bad_record(bad_record_params) do
      {:ok, bad_record} ->
        conn
        |> put_flash(:info, "Bad record created successfully.")
        |> redirect(to: Routes.bad_record_path(conn, :show, bad_record))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bad_record = BadRecords.get_bad_record!(id)
    render(conn, "show.html", bad_record: bad_record)
  end

  def edit(conn, %{"id" => id}) do
    bad_record = BadRecords.get_bad_record!(id)
    changeset = BadRecords.change_bad_record(bad_record)
    render(conn, "edit.html", bad_record: bad_record, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bad_record" => bad_record_params}) do
    bad_record = BadRecords.get_bad_record!(id)

    case BadRecords.update_bad_record(bad_record, bad_record_params) do
      {:ok, bad_record} ->
        conn
        |> put_flash(:info, "Bad record updated successfully.")
        |> redirect(to: Routes.bad_record_path(conn, :show, bad_record))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bad_record: bad_record, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bad_record = BadRecords.get_bad_record!(id)
    {:ok, _bad_record} = BadRecords.delete_bad_record(bad_record)

    conn
    |> put_flash(:info, "Bad record deleted successfully.")
    |> redirect(to: Routes.bad_record_path(conn, :index))
  end
end

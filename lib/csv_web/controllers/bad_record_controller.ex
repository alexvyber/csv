defmodule CsvWeb.BadRecordController do
  use CsvWeb, :controller

  alias Csv.BadRecords
  alias Csv.BadRecords.BadRecord

  def index(conn, _params) do
    bad_records = BadRecords.list_bad_records()
    render(conn, "index.html", bad_records: bad_records)
  end

  def show(conn, %{"id" => id}) do
    bad_record = BadRecords.get_bad_record!(id)
    render(conn, "show.html", bad_record: bad_record)
  end
end

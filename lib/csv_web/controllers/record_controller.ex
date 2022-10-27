defmodule CsvWeb.RecordController do
  use CsvWeb, :controller

  alias Csv.Records
  alias Csv.Records.Record

  def index(conn, _params) do
    records = Records.list_records()
    render(conn, "index.html", records: records)
  end

  def show(conn, %{"id" => id}) do
    record = Records.get_record!(id)
    render(conn, "show.html", record: record)
  end
end

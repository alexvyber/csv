defmodule CsvWeb.RecordController do
  use CsvWeb, :controller

  alias Csv.Records

  def show(conn, %{"id" => id}) do
    record = Records.get_record!(id)
    IO.inspect(record)
    render(conn, "show.html", record: record)
  end
end

defmodule CsvWeb.FileUploadController do
  use CsvWeb, :controller

  alias Csv.Files

  def index(conn, _params) do
    files = Files.list_files()
    changeset = Files.change_file(%Files.File{})
    render(conn, "index.html", files: files, changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    file = Files.get_file_by_file_path!(id)
    records = Csv.Records.list_records_by_file_id!(file.id)
    render(conn, "show.html", file: file, records: records)
  end

  def create(conn, %{"file" => file}) do
    if upload = file["file"] do
      extension = Path.extname(upload.filename)
      base_filename = String.replace(upload.filename, extension, "")

      filepath =
        "#{base_filename}-#{DateTime.utc_now() |> DateTime.to_string() |> String.replace([" ", ":", "."], "-")}#{extension}"

      File.cp(upload.path, "/media/#{filepath}")

      case Files.create_file(%{
             file_name: base_filename,
             file_path: filepath
           }) do
        {:ok, file} ->
          file_content = File.read!("/media/#{file.file_path}")
          # IO.inspect(file_content, label: :file_content)

          parsed_content = Files.parse_content(file_content, ";")
          %{"bad" => bad} = parsed_content
          %{"good" => good} = parsed_content

          number_of_errors = length(bad)

          number_of_errors =
            Enum.reduce(good, number_of_errors, fn %{"processed" => attrs}, number_of_errors ->
              case Csv.Records.create_record(attrs, file) do
                {:ok, _} -> number_of_errors
                {:error, _} -> number_of_errors + 1
              end
            end)

          Files.update_file(file, %{"errors" => number_of_errors})

          conn
          |> put_flash(:info, "File uploaded successfully.")
          |> redirect(to: Routes.file_upload_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:error, "Error while uploading file.")
          |> redirect(to: Routes.file_upload_path(conn, :index))
      end
    end

    conn
    |> put_flash(:info, "File created successfully.!!!")
    |> redirect(to: Routes.file_upload_path(conn, :show, "path-4"))
  end

  def search(conn, %{"query" => query}) do
    records = Csv.Records.search_records(query)
    render(conn, "search-results.html", records: records)
  end
end

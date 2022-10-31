defmodule Csv.Files do
  @moduledoc """
  The Files context.
  """

  import Ecto.Query, warn: false
  alias Csv.Repo

  alias Csv.Files.File

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_files do
    Repo.all(
      from(
        f in File,
        order_by: [desc: f.inserted_at]
      )
    )
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file!(id), do: Repo.get!(File, id)

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{data: %File{}}

  """
  def change_file(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end

  def get_file_by_file_path!(file_path) do
    Repo.get_by!(File, file_path: file_path)
  end

  # ----------------------------
  # FIX: all code above should be in it's own module
  def is_length_right?(%{"valid" => false} = row_map, _length) do
    row_map
  end

  def is_length_right?(%{"valid" => true, "row" => row} = row_map, length) do
    if length(row) === length do
      row_map
    else
      Map.put(row_map, "valid", false)
    end
  end

  def parse_uid_strict(%{"valid" => false} = row_map, _prefix) do
    row_map
  end

  def parse_uid_strict(%{"valid" => true, "row" => [uid | rest]} = row_map, prefix) do
    if String.length(uid) <= 3 do
      Map.put(row_map, "valid", false)
    else
      if String.starts_with?(uid, prefix) do
        %{"valid" => true, "row" => rest, "processed" => %{"uid" => uid}}
      else
        Map.put(row_map, "valid", false)
      end
    end
  end

  def parse_uid_loose(%{"valid" => false} = row_map, _prefix) do
    row_map
  end

  def parse_uid_loose(
        %{"valid" => true, "row" => [uid | rest], "processed" => processed} = row_map,
        prefix
      ) do
    if String.length(uid) <= 3 do
      row_map
    else
      if String.starts_with?(uid, prefix) do
        %{"valid" => true, "row" => rest, "processed" => Map.put(processed, "link", uid)}
      else
        %{"valid" => true, "row" => rest, "processed" => Map.put(processed, "link", "")}
      end
    end
  end

  def is_date_right?(date) do
    date
  end

  def parse_description(%{"valid" => false} = row_map) do
    row_map
  end

  def normalise_datetime_string(str) do
    String.replace(str, ".", "-")
  end

  def parse_description(
        %{"valid" => true, "row" => [description | rest], "processed" => processed} = row_map
      ) do
    case is_binary(description) do
      true ->
        %{
          "valid" => true,
          "row" => rest,
          "processed" => Map.put(processed, "description", description)
        }

      _ ->
        IO.inspect(description)
        Map.put(row_map, "valid", true)
    end
  end

  def parse_date(%{"valid" => false} = row_map) do
    row_map
  end

  def parse_date(
        %{"valid" => true, "row" => [datetime | rest], "processed" => processed} = row_map
      ) do
    normalized_datetime = normalise_datetime_string(datetime)

    case NaiveDateTime.from_iso8601(normalized_datetime) do
      {:ok, datetime} ->
        # true ->
        # IO.inspect(date, label: :here)
        %{
          "valid" => true,
          "row" => rest,
          "processed" => Map.put(processed, "date_created", datetime)
        }

      {:error, _} ->
        IO.puts("there")
        Map.put(row_map, "valid", false)
    end
  end

  def parse_row(row, %{"good" => good, "bad" => bad}) do
    processed_row =
      %{"valid" => true, "row" => row, "processed" => %{}}
      |> is_length_right?(4)
      |> parse_uid_strict("PX_")
      |> parse_description()
      |> parse_date()
      |> parse_uid_loose("PX_")

    # |> IO.inspect(label: "after")

    %{"valid" => valid} = processed_row

    case valid do
      true ->
        %{"good" => [processed_row | good], "bad" => [bad]}

      _ ->
        %{"good" => [good], "bad" => [processed_row | bad]}
    end
  end

  def parse_rows(rows) do
    %{"good" => good, "bad" => bad} =
      Enum.reduce(rows, %{"good" => [], "bad" => []}, fn row, acc ->
        parse_row(row, acc)
      end)

    %{"good" => List.flatten(good), "bad" => List.flatten(bad)}
  end

  def parse_content(content, separator) do
    # split rows
    # parsed_rows =
    String.split(content, "\n")
    # split columns
    |> Enum.map(fn row -> String.split(row, separator) end)
    |> parse_rows()
  end
end

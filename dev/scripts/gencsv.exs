defmodule GenCSV do
  use Task

  @alphabet Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)

  def start_link(opts) do
    Task.start_link(__MODULE__, :run, opts)
  end

  def run(number_of_lines, file_name),
    do: generate_csv_file(number_of_lines, file_name, ";")

  def run(number_of_lines, file_name, :comma),
    do: generate_csv_file(number_of_lines, file_name, ",")

  def run(number_of_lines, file_name, _separator),
    do: generate_csv_file(number_of_lines, file_name, ";")

  defp generate_csv_file(number_of_lines, file_name, separator) do
    {:ok, file} = File.open("dev/files/#{file_name}.csv", [:write])

    1..number_of_lines
    |> Enum.map(fn _x ->
      generate_row(separator, number_of_lines)
      |> (&IO.write(file, &1)).()
    end)

    File.close(file)

    # {:ok, "#{number_of_lines} written to file: #{file_name}.csv with separator `#{separator}`"}
    "/home/alexs/work/tests/ex-test/csv/dev/files/#{file_name}.csv"
  end

  defp generate_row(separator, id_range) do
    # leadning separator
    "#{if 0..id_range |> Enum.random() < 10, do: "#{separator}", else: ""}"
    # identificator
    |> (&"#{&1}#{if 0..id_range |> Enum.random() > 10, do: "PX_#{1..id_range |> Enum.random()}", else: ""}").()
    # random string
    |> (&"#{&1}#{separator}#{if 0..10 |> Enum.random() > 5, do: Enum.take_random(@alphabet, 1..25 |> Enum.random()), else: ""}").()
    # date
    |> (&"#{&1}#{separator}#{if 0..100 |> Enum.random() > 1, do: Calendar.strftime(DateTime.utc_now(), "%Y.%m.%d %I:%M:%S"), else: ""}").()
    # link
    |> (&"#{&1}#{separator}#{if 0..10 |> Enum.random() > 5, do: "PX_#{1..id_range |> Enum.random()}", else: ""}").()
    # trailing separator
    |> (&"#{&1}#{if 0..100 |> Enum.random() < 2, do: "#{separator}", else: ""}\n").()
  end
end

IO.inspect(
  GenCSV.run(
    1000,
    "regular-comma-#{Calendar.strftime(DateTime.utc_now(), "%Y.%m.%d--%I-%M-%S")}"
  )
)

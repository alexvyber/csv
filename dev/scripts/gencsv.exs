defmodule GenCSV do
  @alphabet Enum.to_list(?a..?z)

  def generate_csv_file(number_of_lines, file_name, separator) do
    {:ok, file} = File.open("dev/files/#{file_name}-#{number_of_lines}.csv", [:write])

    {start, ""} = File.read!("dev/scripts/count") |> Integer.parse()

    range_end = start + number_of_lines

    (start + 1)..(range_end - 1)
    |> Enum.map(fn _x ->
      generate_row(separator, start + 1, range_end)
      |> (&IO.write(file, &1)).()
    end)

    # write last to the file without line break
    generate_row(separator, start + 1, range_end)
    |> String.replace("\n", "")
    |> (&IO.write(file, &1)).()

    File.close(file)

    # increment counter in file
    # it was needed to regenerate filex with new ranges of uids
    {:ok, count_file} = File.open("dev/scripts/count", [:write])
    IO.write(count_file, start + number_of_lines)
    File.close(count_file)

    {:ok,
     "#{number_of_lines} lines written to file: #{file_name}.csv with separator `#{separator}`"}
  end

  def generate_good_csv_file(number_of_lines, file_name, separator) do
    {:ok, file} = File.open("dev/files/#{file_name}-#{number_of_lines}.csv", [:write])

    {start, ""} = File.read!("dev/scripts/count_good") |> Integer.parse()

    range_end = start + number_of_lines

    (start + 1)..(range_end - 1)
    |> Enum.map(fn x ->
      generate_good_row(x, separator)
      |> (&IO.write(file, &1)).()
    end)

    # write last to the file without line break
    generate_good_row(range_end, separator)
    |> String.replace("\n", "")
    |> (&IO.write(file, &1)).()

    File.close(file)

    # increment counter in file
    # it was needed to regenerate filex with new ranges of uids
    {:ok, count_file} = File.open("dev/scripts/count_good", [:write])
    IO.write(count_file, start + number_of_lines)
    File.close(count_file)

    {:ok,
     "#{number_of_lines} lines written to file: #{file_name}.csv with separator `#{separator}`"}
  end

  defp generate_row(separator, range_start, range_end) do
    # leadning separator
    "#{if 0..100 |> Enum.random() < 5, do: "#{separator}", else: ""}"
    # identificator
    |> (&"#{&1}#{if 0..100 |> Enum.random() > 10, do: "PX_#{range_start..range_end |> Enum.random()}", else: "#{Enum.take_random(@alphabet, 2) |> to_string() |> String.upcase()}_#{range_start..range_end |> Enum.random()}"}").()
    # random string
    |> (&"#{&1}#{separator}#{if 0..10 |> Enum.random() > 5, do: Enum.take_random(@alphabet, 1..25 |> Enum.random()), else: ""}").()
    # date
    |> (&"#{&1}#{separator}#{if 0..100 |> Enum.random() > 1, do: Calendar.strftime(DateTime.utc_now(), "%Y.%m.%d %I:%M:%S"), else: "25.10.2022 18/03/33"}").()
    # link
    |> (&"#{&1}#{separator}#{if 0..10 |> Enum.random() > 5, do: "PX_#{1..range_end |> Enum.random()}", else: ""}").()
    # trailing separator
    |> (&"#{&1}#{if 0..100 |> Enum.random() < 5, do: "#{separator}", else: ""}\n").()
  end

  defp generate_good_row(uid_number, separator) do
    get_uid(uid_number) <>
      separator <>
      if(rem(uid_number, 3) !== 0, do: get_description(), else: "") <>
      separator <>
      get_date() <>
      separator <>
      if(rem(uid_number, 5) !== 0, do: get_uid(Enum.random(1..uid_number)), else: "") <> "\n"
  end

  defp get_uid(uid_number) do
    "PX_#{uid_number}"
  end

  defp get_description() do
    "#{Enum.take_random(@alphabet, 1..25 |> Enum.random())}"
  end

  defp get_date() do
    Calendar.strftime(DateTime.utc_now(), "%Y.%m.%d %I:%M:%S")
  end
end

{:ok, reg} = GenCSV.generate_csv_file(100, "errors", ";")
{:ok, good} = GenCSV.generate_good_csv_file(100_000, "without-errors", ";")

IO.puts(reg)
IO.puts(good)

defmodule Csv.FilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Csv.Files` context.
  """

  @doc """
  Generate a unique file file_name.
  """
  def unique_file_file_name, do: "some file_name#{System.unique_integer([:positive])}"

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        file_name: unique_file_file_name(),
        file_path: "some file_path"
      })
      |> Csv.Files.create_file()

    file
  end
end

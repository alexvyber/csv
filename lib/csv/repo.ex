defmodule Csv.Repo do
  use Ecto.Repo,
    otp_app: :csv,
    adapter: Ecto.Adapters.Postgres
end

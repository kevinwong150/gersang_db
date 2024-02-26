defmodule GersangDb.Repo do
  use Ecto.Repo,
    otp_app: :gersang_db,
    adapter: Ecto.Adapters.Postgres
end

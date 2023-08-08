defmodule Supapi.Repo do
  use Ecto.Repo,
    otp_app: :supapi,
    adapter: Ecto.Adapters.Postgres
end

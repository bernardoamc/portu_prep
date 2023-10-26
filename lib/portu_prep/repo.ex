defmodule PortuPrep.Repo do
  use Ecto.Repo,
    otp_app: :portu_prep,
    adapter: Ecto.Adapters.SQLite3
end

defmodule ILikeTrains.Repo do
  use Ecto.Repo,
    otp_app: :i_like_trains,
    adapter: Ecto.Adapters.Postgres
end

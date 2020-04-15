use Mix.Config

# Configure your database
config :i_like_trains, ILikeTrains.Repo,
  username: "postgres",
  password: "postgres",
  database: "i_like_trains_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :i_like_trains, ILikeTrainsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

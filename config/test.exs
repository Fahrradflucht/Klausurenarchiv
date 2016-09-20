use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :klausurenarchiv, Klausurenarchiv.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :klausurenarchiv, Klausurenarchiv.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: System.get_env("KLAUSURENARCHIV_DB_PASS") || "postgres",
  database: "klausurenarchiv_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :klausurenarchiv,
  ecto_repos: [Klausurenarchiv.Repo]

# Configures the endpoint
config :klausurenarchiv, Klausurenarchiv.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hlpRvmUizCBcBsH6O2vByi2uxk93MAj5pQve/Ia7gktYHGOf/KrP5/N3C8JpkGTj",
  render_errors: [view: Klausurenarchiv.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Klausurenarchiv.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    facebook: {Ueberauth.Strategy.Facebook, [profile_fields: "name, email, first_name, last_name"]}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

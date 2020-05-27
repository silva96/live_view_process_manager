# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :process_manager, ProcessManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yYuc4CUcrw6RuLZ9Neft8c8QVj45W2iM/7oO0BsRow0Ofz4dFDQfK+vpZbi6gj5A",
  render_errors: [view: ProcessManagerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ProcessManager.PubSub,
  live_view: [signing_salt: "uRJnF03t"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

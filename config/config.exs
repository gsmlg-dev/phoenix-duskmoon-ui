# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :phx_wc_storybook,
  namespace: PhxWCStorybook

config :phx_wc_storybook_web,
  namespace: PhxWCStorybookWeb,
  generators: [context_app: :phx_wc_storybook]

# Configures the endpoint
config :phx_wc_storybook_web, PhxWCStorybookWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PhxWCStorybookWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhxWCStorybook.PubSub,
  live_view: [signing_salt: "HkF5qV0r"]

config :phx_wc_storybook_web, PhxWCStorybookWeb.Storybook,
  js_path: "/assets/app.js",
  css_path: "/assets/app.css"

config :tailwind,
  version: "3.1.6",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/phoenix_webcomponent.css
      --output=../priv/static/phoenix_webcomponent.css
    ),
    cd: Path.expand("../apps/phoenix_webcomponent/assets", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../deps", __DIR__)}:#{Path.expand("../apps", __DIR__)}"}
  ],
  storybook: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/phx_wc_storybook_web/assets", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../deps", __DIR__)}:#{Path.expand("../apps", __DIR__)}"}
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args: ~w(js/phoenix_webcomponent.js --target=es2021 --format=iife --outdir=../priv/static/),
    cd: Path.expand("../apps/phoenix_webcomponent/assets", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../apps", __DIR__)}:#{Path.expand("../deps", __DIR__)}"}
  ],
  storybook: [
    args:
      ~w(js/app.js --bundle --format=iife --target=es2021 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/phx_wc_storybook_web/assets", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../deps", __DIR__)}:#{Path.expand("../apps", __DIR__)}"}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

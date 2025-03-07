import Config

config :duskmoon_storybook,
  namespace: DuskmoonStorybook

config :duskmoon_storybook_web,
  namespace: DuskmoonStorybookWeb,
  generators: [context_app: :duskmoon_storybook]

config :duskmoon_storybook_web, DuskmoonStorybookWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: DuskmoonStorybookWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DuskmoonStorybook.PubSub,
  live_view: [signing_salt: "HkF5qV0r"]

config :duskmoon_storybook_web, Storybook,
  js_path: "/assets/app.js",
  css_path: "/assets/app.css"

config :tailwind,
  version: "4.0.6",
  duskmoon: [
    args: ~w(
      --input=assets/css/phoenix_duskmoon.css
      --output=priv/static/phoenix_duskmoon.css
    ),
    cd: Path.expand("../apps/phoenix_duskmoon", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../deps", __DIR__)}:#{Path.expand("../apps", __DIR__)}"}
  ],
  storybook: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/duskmoon_storybook_web", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../deps", __DIR__)}:#{Path.expand("../apps", __DIR__)}"}
  ]

config :esbuild,
  version: "0.25.0",
  duskmoon: [
    args: ~w(assets/js/phoenix_duskmoon.js --target=es2021 --format=iife --outdir=priv/static/),
    cd: Path.expand("../apps/phoenix_duskmoon", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../apps", __DIR__)}:#{Path.expand("../deps", __DIR__)}"}
  ],
  storybook: [
    args:
      ~w(assets/js/app.js --bundle --format=iife --target=es2021 --outdir=priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/duskmoon_storybook_web", __DIR__),
    env: %{"NODE_PATH" => "#{Path.expand("../deps", __DIR__)}:#{Path.expand("../apps", __DIR__)}"}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

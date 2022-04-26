import Config

config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.14.0",
  default: [
    args: ~w(priv/src/phoenix_webcomponent.js --bundle --minify --target=esnext --outdir=priv/static/),
    cd: Path.expand("../", __DIR__)
  ]

import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :duskmoon_storybook_web, DuskmoonStorybookWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4600],
  secret_key_base: "u4CGMLvZGj1B4C7in/ai2kZWRpAPYjbpWB5kNiGeYVbPuZsv2wO3DTR71X6QiJ6l",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

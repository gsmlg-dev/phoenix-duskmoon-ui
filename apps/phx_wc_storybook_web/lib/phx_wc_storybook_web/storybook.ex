defmodule PhxWCStorybookWeb.Storybook do
  @moduledoc false
  use PhoenixStorybook,
    # OTP name of your application.
    otp_app: :phx_wc_storybook_web,

    # Path to your storybook stories (required).
    content_path: Path.expand("storybook", __DIR__),

    # Custom storybook title. Default is "Storybook".
    title: "Phoenix WebComponent Storybook",

    # Story compilation mode, can be either `:eager` or `:lazy`.
    # It defaults to `:lazy` in dev environment, `:eager` in other environments.
    #   - When eager: all .story.exs & .index.exs files are compiled upfront.
    #   - When lazy: ony .index.exs files are compiled upfront and .story.exs are compile when the
    #     matching story is loaded in UI.
    compilation_mode: :eager
end

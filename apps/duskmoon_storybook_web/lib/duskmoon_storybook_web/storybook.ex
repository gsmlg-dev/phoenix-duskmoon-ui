defmodule DuskmoonStorybookWeb.Storybook do
  use PhoenixStorybook,
    otp_app: :duskmoon_storybook_web,

    content_path: Path.expand("storybook", __DIR__),

    # Story compilation mode, can be either `:eager` or `:lazy`.
    # It defaults to `:lazy` in dev environment, `:eager` in other environments.
    #   - When eager: all .story.exs & .index.exs files are compiled upfront.
    #   - When lazy: ony .index.exs files are compiled upfront and .story.exs are compile when the
    #     matching story is loaded in UI.
    compilation_mode: :eager
end

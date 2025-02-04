defmodule DuskmoonStorybookWeb.Storybook do
  use PhoenixStorybook,
    otp_app: :duskmoon_storybook_web,
    content_path: Path.expand("storybook", __DIR__),

    # Path to your JS asset, which will be loaded just before PhoenixStorybook's own
    # JS. It's mainly intended to define your LiveView Hooks in `window.storybook.Hooks`.
    # Remote path (not local file-system path) which means this file should be served
    # by your own application endpoint.
    js_path: "/assets/storybook.js",

    # Path to your components stylesheet.
    # Remote path (not local file-system path) which means this file should be served
    # by your own application endpoint.
    css_path: "/assets/storybook.css",

    # Custom storybook title. Default is "Live Storybook".
    title: "Phoenix Duskmoon UI Storybook",

    # Story compilation mode, can be either `:eager` or `:lazy`.
    # It defaults to `:lazy` in dev environment, `:eager` in other environments.
    #   - When eager: all .story.exs & .index.exs files are compiled upfront.
    #   - When lazy: ony .index.exs files are compiled upfront and .story.exs are compile when the
    #     matching story is loaded in UI.
    compilation_mode: :eager
end

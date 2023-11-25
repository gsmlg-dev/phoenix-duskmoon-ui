defmodule DuskmoonStorybookWeb.Storybook do
  use PhoenixStorybook,
    otp_app: :duskmoon_storybook_web,
    content_path: Path.expand("./storybook", __DIR__),
    # assets path are remote path, not local file-system paths
    title: "Duskmoon UI Storybook",
    css_path: "/assets/storybook.css",
    js_path: "/assets/storybook.js",
    sandbox_class: "duskmoon-storybook-web"
end

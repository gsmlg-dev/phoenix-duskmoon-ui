defmodule DuskmoonStorybookWeb.Storybook.Components.Link do
  # :live_component or :page are also available
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Link.wc_link/1
  def description, do: "Recreate Phoenix.Component.link with custom element."

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          href: "/"
        },
        slots: [
          """
          Back to home
          """
        ]
      },
      %Variation{
        id: :primary,
        attributes: %{
          href: "/",
          mode: "primary"
        },
        slots: [
          """
          Back to home
          """
        ]
      },
      %Variation{
        id: :round,
        attributes: %{
          href: "/",
          mode: "round"
        },
        slots: [
          """
          Back to home
          """
        ]
      }
    ]
  end
end

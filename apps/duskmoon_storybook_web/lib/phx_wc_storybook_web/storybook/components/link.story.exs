defmodule DuskmoonStorybookWeb.Storybook.Components.Link do
  # :live_component or :page are also available
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Link.dm_link/1
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
          class: "btn-primary"
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
          class: "btn-round"
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

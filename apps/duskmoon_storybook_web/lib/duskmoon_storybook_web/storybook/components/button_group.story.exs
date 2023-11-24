defmodule DuskmoonStorybookWeb.Storybook.Components.ButtonGroup do
  # :live_component or :page are also available
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.ButtonGroup.dm_toggle_button_group/1
  def description, do: "A button group element."

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          class: ""
        },
        slots: [
          """
          """
        ]
      }
    ]
  end
end

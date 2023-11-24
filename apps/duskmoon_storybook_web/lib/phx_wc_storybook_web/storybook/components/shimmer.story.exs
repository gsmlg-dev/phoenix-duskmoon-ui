defmodule DuskmoonStorybookWeb.Storybook.Components.Shimmer do
  # :live_component or :page are also available
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Shimmer.dm_shimmer/1
  def description, do: "Shimmer Effect EX."

  def variations do
    [
      %Variation{
        id: :default,
        slots: []
      },
      %Variation{
        id: :with_attributes,
        attributes: %{
          class: "w-32 h-24",
        },
        slots: []
      }
    ]
  end
end

defmodule DuskmoonStorybookWeb.Storybook.Components.Tab do
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Tab.dm_tab/1

  def template do
    """
    <div>
      <.lsb-variation />
    </div>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          active_tab: 0
        },
        slots: [
          ~s(<:tab>Tab 1</:tab>),
          ~s(<:tab>Tab 2</:tab>)
        ]
      },
    ]
  end
end

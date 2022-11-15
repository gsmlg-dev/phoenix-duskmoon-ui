defmodule PhxWCStorybookWeb.Storybook.Components.LeftMenu do
  # :live_component or :page are also available
  use PhxLiveStorybook.Story, :component

  def function, do: &Phoenix.WebComponent.LeftMenu.wc_left_menu/1
  def description, do: "A left menu element."

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          active: "left_menu",
          menus: [
            {"Components",
             [
               {"actionbar", "Actionbar", "/storybook/components/actionbar"},
               {"card", "Card", "/storybook/components/card"},
               {"left_menu", "Left Menu", "/storybook/components/left_menu"},
               {"markdown", "Markdown", "/storybook/components/markdown"},
               {"pagination", "Pagination", "/storybook/components/pagination"},
               {"table", "Table", "/storybook/components/table"}
             ]}
          ]
        },
        slots: ["<:title>Menu Demo Components</:title>"]
      }
    ]
  end
end

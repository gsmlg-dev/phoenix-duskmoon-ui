defmodule DuskmoonStorybookWeb.Storybook.Components.Breadcrumb do
  # :live_component or :page are also available
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Breadcrumb.dm_breadcrumb/1
  def description, do: "A breadcrumb element."

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          class: "shadow"
        },
        slots: [
          """
          <:crumb>
            <a href="/">Home</a>
          </:crumb>
          <:crumb>
            <button>Page</button>
          </:crumb>
          """
        ]
      },
      %Variation{
        id: :custom_icon,
        attributes: %{
          class: "bg-white text-slate-600"
        },
        slots: [
          """
          <:icon>
          <PhoenixDuskmoon.Icons.dm_mdi name="home-assistant" class="w-4 h-4" />
          </:icon>
          """,
          """
          <:crumb>
            <a href="/">Home</a>
          </:crumb>
          <:crumb>
            <button>Page</button>
          </:crumb>
          """
        ]
      }
    ]
  end
end

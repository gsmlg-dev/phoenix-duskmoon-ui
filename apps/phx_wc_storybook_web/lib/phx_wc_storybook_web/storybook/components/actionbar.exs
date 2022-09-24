defmodule PhxWCStorybookWeb.Storybook.Components.Actionbar do
  # :live_component or :page are also available
  use PhxLiveStorybook.Entry, :component

  def function, do: &Phoenix.WebComponent.Actionbar.wc_actionbar/1
  def description, do: "A actionbar element."

  def stories do
    [
      %Story{
        id: :default,
        attributes: %{
          class: "shadow"
        },
        slots: ["""
        <:left>
          Star Wars
        </:left>
        <:right>
          <button>action</button>
        </:right>
        """]
      }
    ]
  end
end

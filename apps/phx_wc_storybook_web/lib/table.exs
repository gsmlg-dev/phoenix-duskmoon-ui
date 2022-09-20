defmodule PhxWCStorybookWeb.Storybook.Components.Table do
  # :live_component or :page are also available
  use PhxLiveStorybook.Entry, :component

  def function, do: &Phoenix.WebComponent.Table.wc_table/1
  def description, do: "A markdown render element."

  def stories do
    [
      %Story{
        id: :default,
        attributes: %{
          cols: [%{label: "Name"}]
        }
      },
    ]
  end
end

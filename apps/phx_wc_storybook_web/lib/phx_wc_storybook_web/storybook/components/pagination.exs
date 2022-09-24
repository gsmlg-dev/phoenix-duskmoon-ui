defmodule PhxWCStorybookWeb.Storybook.Components.Pagination do
  # :live_component or :page are also available
  use PhxLiveStorybook.Entry, :component

  def function, do: &Phoenix.WebComponent.Pagination.wc_pagination/1
  def description, do: "A pagination element."

  def stories do
    [
      %Story{
        id: :default,
        attributes: %{
          total: 100,
          page_num: 5,
          page_size: 15,
          update_event: "ignore"
        }
      }
    ]
  end
end

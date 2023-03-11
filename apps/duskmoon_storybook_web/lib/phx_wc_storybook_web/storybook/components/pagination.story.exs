defmodule DuskmoonStorybookWeb.Storybook.Components.Pagination do
  # :live_component or :page are also available
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Pagination.wc_pagination/1
  def description, do: "A pagination element."

  def variations do
    [
      %Variation{
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

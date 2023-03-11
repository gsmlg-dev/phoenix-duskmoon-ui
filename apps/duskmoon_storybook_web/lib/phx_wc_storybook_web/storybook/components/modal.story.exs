defmodule DuskmoonStorybookWeb.Storybook.Components.Modal do
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Modal.wc_modal/1

  def imports do
    [{PhoenixDuskmoon.Modal, wc_show_modal: 0}]
  end

  def template do
    """
    <div>
      <button type="button" class="btn" phx-click={wc_show_modal()}>
        Open modal
      </button>
      <.lsb-variation />
    </div>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        slots: [
          "<:title>PhoenixDuskmoon</:title>",
          "<:body>PhoenixDuskmoon Storybook</:body>"
        ]
      },
      %Variation{
        id: :with_buttons,
        slots: [
          """
          <:title>
            PhoenixDuskmoon
          </:title>
          """,
          """
          <:body>
            PhoenixDuskmoonb Storybook
            Show Modal
          </:body>
          """,
          """
          <:button>
            <button type="button" class="btn">
              Cancel
            </button>
          </:button>
          """,
          """
          <:button>
            <button type="button" class="btn">
              OK
            </button>
          </:button>
          """
        ]
      },
      %Variation{
        id: :without_title,
        slots: [
          """
          <:body>
            PhoenixDuskmoonb Is Awesome
          </:body>
          """,
          """
          <:button>
            <button type="button" class="btn">
              OK
            </button>
          </:button>
          """
        ]
      }
    ]
  end
end

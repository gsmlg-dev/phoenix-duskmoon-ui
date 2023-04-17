defmodule DuskmoonStorybookWeb.Storybook.Components.Modal do
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Modal.dm_modal/1

  def imports do
    [{PhoenixDuskmoon.Modal, dm_show_modal: 0}]
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{},
        slots: [
          """
          <:trigger let={f}>
            <button phx-click={f}>Open</button>
          </:trigger>
          """,
          "<:title>PhoenixDuskmoon</:title>",
          "<:body>PhoenixDuskmoon Storybook</:body>"
        ]
      },
      %Variation{
        id: :with_buttons,
        slots: [
          """
          <:trigger let={f}>
            <button phx-click={f}>Open</button>
          </:trigger>
          """,
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
          <:footer>
            <button type="button" class="btn">
              Cancel
            </button>
            <button type="button" class="btn">
              OK
            </button>
          </:footer>
          """
        ]
      },
      %Variation{
        id: :without_title,
        slots: [
          """
          <:trigger let={f}>
            <button phx-click={f}>Open</button>
          </:trigger>
          """,
          """
          <:body>
            PhoenixDuskmoonb Is Awesome
          </:body>
          """,
          """
          <:footer>
            <button type="button" class="btn">
              OK
            </button>
          </:footer>
          """
        ]
      }
    ]
  end
end

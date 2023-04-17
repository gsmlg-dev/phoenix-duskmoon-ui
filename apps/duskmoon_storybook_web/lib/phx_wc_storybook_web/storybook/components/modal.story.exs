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
          <:footer let={f}>
            <button class="btn" phx-click={f}>
              Cancel
            </button>
            <button class="btn">
              OK
            </button>
          </:footer>
          """
        ]
      },
      %Variation{
        id: :without_title_and_close,
        attributes: %{
          hide_close: true
        },
        slots: [
          """
          <:trigger let={f}>
            <button phx-click={f}>Open</button>
          </:trigger>
          """,
          """
          <:body let={close} class="flex justify-center items-center text-4xl text-rose-600">
            <button phx-click={close}>PhoenixDuskmoonb Is Awesome...</button>
          </:body>
          """
        ]
      }
    ]
  end
end

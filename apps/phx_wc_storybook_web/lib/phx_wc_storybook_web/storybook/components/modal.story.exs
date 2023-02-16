defmodule PhxWCStorybookWeb.Storybook.Components.Modal do
  use PhxLiveStorybook.Story, :component

  def function, do: &Phoenix.WebComponent.Modal.wc_modal/1

  def imports do
    [{Phoenix.WebComponent.Modal, wc_show_modal: 0}]
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
          "<:title>Phoenix WebComponent</:title>",
          "<:body>Phoenix WebComponent Storybook</:body>",
        ],
      },
      %Variation{
        id: :with_buttons,
        slots: [
          """
          <:title>
            Phoenix WebComponent
          </:title>
          """,
          """
          <:body>
            Phoenix WebComponentb Storybook
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
          """,
        ],
      },
      %Variation{
        id: :without_title,
        slots: [
          """
          <:body>
            Phoenix WebComponentb Is Awesome
          </:body>
          """,
          """
          <:button>
            <button type="button" class="btn">
              OK
            </button>
          </:button>
          """,
        ],
      },
    ]
  end
end

defmodule PhxWCStorybookWeb.Storybook.Components.Actionbar do
  # :live_component or :page are also available
  use PhxLiveStorybook.Story, :component

  def function, do: &Phoenix.WebComponent.Actionbar.wc_actionbar/1
  def description, do: "A actionbar element."

  def variations do [
    %Variation{
      id: :default,
      attributes: %{
        class: "shadow"
      },
      slots: [
        """
        <:left>
          Star Wars
        </:left>
        <:right>
          <button>action</button>
        </:right>
        """
      ]
    }
  ]
  end

end

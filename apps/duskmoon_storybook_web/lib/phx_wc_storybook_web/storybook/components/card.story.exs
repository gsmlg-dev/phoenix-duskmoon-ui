defmodule DuskmoonStorybookWeb.Storybook.Components.Card do
  # :live_component or :page are also available
  use PhoenixStorybook.Story, :component

  def function, do: &PhoenixDuskmoon.Card.dm_card/1
  def description, do: "A card element."

  def variations do
    [
      %Variation{
        id: :default,
        slots: [
          """
          <:title>
          Star Wars
          </:title>
          Star Wars is an American epic space opera multimedia
          franchise created by George Lucas,
          which began with the eponymous 1977 film and
          quickly became a worldwide pop-culture phenomenon.
          """
        ]
      }
    ]
  end
end

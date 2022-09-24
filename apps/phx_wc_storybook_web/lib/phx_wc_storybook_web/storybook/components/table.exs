defmodule PhxWCStorybookWeb.Storybook.Components.Table do
  # :live_component or :page are also available
  use PhxLiveStorybook.Entry, :component

  def function, do: &Phoenix.WebComponent.Table.wc_table/1
  def description, do: "A table element."

  def stories do
    [
      %Story{
        id: :default,
        attributes: %{
          rows: [
            %{
              name: "Shmi Skywalker",
              portrayal: """
              Pernilla August (Episodes I-II)
              Voice: Pernilla August (The Clone Wars)
              """,
              description: """
              Anakin Skywalker's mother, and Luke and Leia's paternal grandmother.
              Qui-Gon Jinn attempts to bargain for her freedom from slavery but fails.
              Shmi encourages Anakin to leave Tatooine with Qui-Gon to seek his destiny,
              but Anakin finds it hard to leave without her.
              A widowed moisture farmer named Cliegg Lars later falls in love with Shmi,
              and after he purchases her freedom from Watto, they marry.
              Shmi dies in Anakin's arms after being kidnapped and tortured by Tusken Raiders in Attack of the Clones.
              """
            },
            %{
              name: "Luke Skywalker",
              portrayal: """
              Mark Hamill (Episodes IV-IX, The Mandalorian, The Book of Boba Fett), Aidan Barton (Episode III), Grant Feely (Obi-Wan Kenobi)
              Body Doubles: Lukaz Leong (Episode IX), Max Lloyd-Jones (The Mandalorian), Graham Hamilton (The Book of Boba Fett)

              Voice: Mark Hamill (Forces of Destiny)
              """,
              description: """
              Former moisture farmer and Jedi Knight whose coming of age and rise as a Jedi are portrayed in the original Star Wars trilogy. He is the son of Anakin Skywalker and Padmé Amidala, Leia Organa's twin brother, and Ben Solo's uncle.[18] After his birth, he was adopted by the Lars family on Tatooine to keep him safe and hidden from the Galactic Empire. After the Empire's defeat, Luke becomes a Jedi Master and attempts to rebuild the Jedi Order, starting with briefly training Grogu,[19] but goes into self-exile on the planet Ahch-To after Ben falls to the dark side, becomes Kylo Ren, and takes part in the murder of his other students. He later reluctantly trains Rey, and dies helping the Resistance escape from the First Order. His Force spirit eventually helps Rey defeat a resurrected Palpatine to end the Sith once and for all, and later gives her his blessing to adopt the Skywalker surname and continue his family's legacy.
              """
            }
          ]
        },
        slots: ["""
        <:col let={r} label="Name">
          <%= r.name %>
        </:col>
        <:col let={r} label="Portrayal">
          <%= r.portrayal %>
        </:col>
        <:col let={r} label="Description">
          <%= r.description %>
        </:col>
        """]
      }
    ]
  end
end

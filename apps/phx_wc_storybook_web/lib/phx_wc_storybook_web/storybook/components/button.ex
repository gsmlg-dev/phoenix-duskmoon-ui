# storybook/components/button.exs
defmodule PhxWCStoryBookWeb.Storybook.Components.Button do
    alias PhxWCStoryBookWeb.Components.Button

    # :live_component or :page are also available
    use PhxLiveStorybook.Entry, :component

    def function, do: &Button.button/1
    def description, do: "A simple generic button."

    def stories do [
      %Story{
        id: :default,
        attributes: %{
          label: "A button"
        }
      },
      %Story{
        id: :green_button,
        attributes: %{
          label: "Still a button",
          color: :green
        }
      }
    ]
    end
  end

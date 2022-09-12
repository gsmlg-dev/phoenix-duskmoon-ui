defmodule PhxWCStorybookWeb.Storybook.Components.Markdown do
  # :live_component or :page are also available
  use PhxLiveStorybook.Entry, :component

  def function, do: &Phoenix.WebComponent.Markdown.wc_markdown/1
  def description, do: "A markdown render element."

  def stories do
    [
      %Story{
        id: :default,
        attributes: %{
          content: """
          # Page title
          """
        }
      },
      %Story{
        id: :with_code,
        attributes: %{
          content: """
          # Code
          ```elixir
          IO.inspect :math.pow(2, 4)
          ```
          """
        }
      },
      %Story{
        id: :with_mermaid,
        attributes: %{
          content: """
          ### Mermaid Chart
          ```mermaid
          graph LR;
              A-->B;
              A-->C;
              B-->D;
              C-->D;
          ```

          ```mermaid
          graph TD;
              A-->B;
              A-->C;
              B-->D;
              C-->D;
          ```
          """
        }
      }
    ]
  end
end

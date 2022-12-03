defmodule Phoenix.WebComponent.Markdown do
  @moduledoc """
  Render markdown in to remark-element.

  The remark-element supported markdown featrues:
    * github flavor
    * auto highlight code with lowlight.js and auto detect system light/dark themes.
    * charts render by mermaid.js

  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates a html customElement remark-element to preview markdown.

  Docs of remark-element (See https://gsmlg-dev.github.io/lit/?path=/story/gsmlg-remark-element--basic).

  ## Examples

      <.wc_markdown content={"# Hello"} class="dark" />
      #=> <remark-element class="dark" content="# Hello"></remark-element>

      <.wc_markdown content={"# Hello"} class="btn" />
      #=> <remark-element class="btn" content="# Hello"></remark-element>

  ## Attributes

    * `id` - `binary`
    remark-element html attribute id

    * `class` - `binary`
    remark-element html attribute class

    * `:debug` - print log in browser console

    * `:content` - The content of markdown, replace innerHTML.

  """
  @doc type: :component
  attr(:id, :string,
    default: "",
    doc: """
    html attribute id
    """
  )

  attr(:class, :string,
    default: "",
    doc: """
    html attribute class
    """
  )

  attr(:debug, :boolean,
    default: false,
    doc: """
    remark-element attribute, enable debug
    """
  )

  attr(:content, :string,
    default: "",
    doc: """
    markdown content
    """
  )

  def wc_markdown(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> false end)
      |> assign_new(:debug, fn -> false end)
      |> assign_new(:content, fn -> "" end)

    ~H"""
    <remark-element id={@id} debug={@debug} class={@class}><%= @content %></remark-element>
    """
  end
end

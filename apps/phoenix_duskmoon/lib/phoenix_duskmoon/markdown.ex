defmodule PhoenixDuskmoon.Markdown do
  @moduledoc """
  Render markdown in to remark-element.

  The remark-element supported markdown featrues:
    * github flavor
    * auto highlight code with lowlight.js and auto detect system light/dark themes.
    * charts render by mermaid.js

  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates a html customElement remark-element to preview markdown.

  Docs of remark-element (See https://gsmlg-dev.github.io/lit/?path=/story/gsmlg-remark-element--basic).

  ## Examples

      <.wc_markdown class="dark"># Hello</.wc_markdown>
      #=> <remark-element class="dark"># Hello</remark-element>

      <.wc_markdown class="btn"># Hello</.wc_markdown>
      #=> <remark-element class="btn"># Hello</remark-element>

  """
  @doc type: :component
  attr(:id, :any,
    default: false,
    doc: """
    html attribute id
    """
  )

  attr(:class, :any,
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
    ~H"""
    <remark-element id={@id} debug={@debug} class={@class}><%= @content %></remark-element>
    """
  end
end

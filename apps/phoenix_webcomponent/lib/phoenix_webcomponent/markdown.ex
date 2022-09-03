defmodule Phoenix.WebComponent.Markdown do
  @moduledoc """
  Render markdown in to remark-element.

  The remark-element supported markdown featrues:
    * github flavor
    * auto highlight code with lowlight.js and auto detect system light/dark themes.
    * charts render by mermaid.js

  """
  use Phoenix.WebComponent, :component

  @doc """
  Generates a html customElement remark-element to preview markdown.

  Docs of remark-element (See https://gsmlg-dev.github.io/lit/?path=/story/gsmlg-remark-element--basic).

  ## Examples

      wc_remark("# Hello", class: "dark")
      #=> <remark-element class="dark" content="# Hello"></remark-element>

      wc_remark(content: "# Hello", class: "btn")
      #=> <remark-element class="btn" content="# Hello"></remark-element>

  ## Options

    * `:debug` - print log in browser console

    * `:content` - The content of markdown, replace innerHTML.

  """
  def remark(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:debug, fn -> false end)
      |> assign_new(:class, fn -> false end)

    ~H"""
    <remark-element id={@id} debug={@debug} class={@class}><%= @content %></remark-element>
    """
  end
end

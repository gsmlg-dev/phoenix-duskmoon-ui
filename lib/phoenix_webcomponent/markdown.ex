defmodule Phoenix.WebComponent.Markdown do
  @moduledoc """
  Render markdown in to remark-element.

  The remark-element supported markdown featrues:
    * github flavor
    * auto highlight code with lowlight.js and auto detect system light/dark themes.
    * charts render by mermaid.js

  """

  import Phoenix.HTML.Tag

  @doc """
  Generates a html customElement remark-element to preview markdown.

  Docs of remark-element (See https://gsmlg-dev.github.io/lit/?path=/story/gsmlg-remark-element--basic).

  Useful to ensure that links that change data are not triggered by
  search engines and other spidering software.

  ## Examples

      wc_remark("# Hello", class: "dark")
      #=> <remark-element class="dark" content="# Hello"></remark-element>

      wc_remark(content: "# Hello", class: "btn")
      #=> <remark-element class="btn" content="# Hello"></remark-element>

  ## Options

    * `:debug` - print log in browser console

    * `:content` - The content of markdown, replace innerHTML.

  All other options are forwarded to the underlying button input.

  """
  def wc_remark(text, opts) when is_binary(text) and is_list(opts) do
    opts = Keyword.put(opts, :content, text)
    wc_remark(opts)
  end

  def wc_remark(text) when is_binary(text) do
    opts = Keyword.put([], :content, text)
    wc_remark(opts)
  end

  def wc_remark(opts) when is_list(opts) do
    {text, opts} = Keyword.pop(opts, :content, "")
    content_tag(:"remark-element", text, opts)
  end
end

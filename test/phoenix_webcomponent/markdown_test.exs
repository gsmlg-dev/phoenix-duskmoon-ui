defmodule Phoenix.WebComponent.MarkdownTest do
  use ExUnit.Case, async: true

  import Phoenix.HTML
  import Phoenix.WebComponent.Markdown

  test "wc_remark empty" do
    assert safe_to_string(wc_remark("")) ==
             ~s[<remark-element></remark-element>]
  end

  test "wc_remark with class" do
    marked = """
    # Hellow World
    """

    assert safe_to_string(wc_remark(marked, class: "light")) ==
      ~s[<remark-element class="light"># Hellow World\n</remark-element>]
  end

  test "wc_remark with content" do
    marked = """
    # Hellow World
    """

    assert safe_to_string(wc_remark(content: marked, class: "light")) ==
      ~s[<remark-element class="light"># Hellow World\n</remark-element>]

  end
end

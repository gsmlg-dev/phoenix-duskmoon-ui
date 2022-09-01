defmodule Phoenix.WebComponent.MarkdownTest do
  use ExUnit.Case, async: true

  require Phoenix.LiveViewTest
  import Phoenix.LiveViewTest
  import Phoenix.WebComponent.Markdown

  test "remark empty" do
    assert render_component(&remark/1, content: "value") ==
             ~s[<remark-element>value</remark-element>]
  end
end

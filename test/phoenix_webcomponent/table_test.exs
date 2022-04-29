defmodule Phoenix.WebComponent.TableTest do
  use ExUnit.Case, async: true

  import Phoenix.HTML
  import Phoenix.WebComponent.Table

  test "wc-table" do
    assert safe_to_string(wc_table([%{name: "Jonathan"}], columns: [name: "Name"])) ==
             ~s[<bx-data-table><bx-table-toolbar><bx-table-batch-actions></bx-table-batch-actions><bx-table-toolbar-content></bx-table-toolbar-content></bx-table-toolbar><bx-table><bx-table-head><bx-table-header-row><bx-table-header-cell sort-active>Name</bx-table-header-cell></bx-table-header-row></bx-table-head><bx-table-body><bx-table-row><bx-table-cell>Jonathan</bx-table-cell></bx-table-row></bx-table-body></bx-table></bx-data-table>]
  end
end

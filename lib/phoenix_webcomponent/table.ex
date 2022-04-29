defmodule Phoenix.WebComponent.Table do
  @moduledoc """
  Render a data table.

  The table is bx-table custom element.

  """

  import Phoenix.HTML.Tag

  @doc """
  Generates a html customElement bx-data-table.

  Docs of bx-data-table (See https://web-components.carbondesignsystem.com/?path=/story/components-data-table--default).

  ## Examples

      wc_table([%{name: "Jonathan"}], [columns: [name: "Name"]])
      #=> <bx-data-table>
      #=> <bx-table>
      #=> <bx-table-head>
      #=> <bx-table-header-row>
      #=> <bx-table-header-cell>Name</bx-table-header-cell>
      #=> </bx-table-header-row>
      #=> </bx-table-head>
      #=> <bx-table-body>
      #=> <bx-table-row>
      #=> <bx-table-cell>Jonathan</bx-table-cell>
      #=> </bx-table-row>
      #=> </bx-table-body>
      #=> </bx-table>
      #=> </bx-data-table>

  ## Options

    * `:columns` - print log in browser console

    * `:content_columns` - columns that have special renderer.

    * `:content_functions` - renderer defined in `:content_columns`

    * `:toolbar_actions` - Action buttons at top right.

  All other options are forwarded to the underlying button input.

  """
  def wc_table(data, opts) do
    {toolbar_actions, opts} = Keyword.pop(opts, :toolbar_actions, [])

    {columns, opts} = Keyword.pop(opts, :columns, [])
    {content_columns, opts} = Keyword.pop(opts, :content_columns, [])
    {content_functions, opts} = Keyword.pop(opts, :content_functions, [])

    content_tag(:"bx-data-table", opts) do
      [
        content_tag(:"bx-table-toolbar", []) do
          [
            content_tag(:"bx-table-batch-actions", []) do
            end,
            content_tag(:"bx-table-toolbar-content", []) do
              toolbar_actions
            end
          ]
        end,
        content_tag(:"bx-table", []) do
          [
            content_tag(:"bx-table-head", []) do
              content_tag(:"bx-table-header-row", []) do
                Enum.map(columns, fn {_, v} ->
                  content_tag(:"bx-table-header-cell", v, "sort-active": true)
                end)
              end
            end,
            content_tag(:"bx-table-body", []) do
              Enum.map(data, fn d ->
                content_tag(:"bx-table-row", []) do
                  Enum.map(columns, fn {k, _} ->
                    if k in content_columns do
                      content_tag(:"bx-table-cell", []) do
                        idx = Enum.find_index(content_columns, fn n -> n == k end)
                        func = Enum.at(content_functions, idx, fn d -> Map.get(d, k) end)
                        func.(d)
                      end
                    else
                      content_tag(:"bx-table-cell", Map.get(d, k), [])
                    end
                  end)
                end
              end)
            end
          ]
        end
      ]
    end
  end
end

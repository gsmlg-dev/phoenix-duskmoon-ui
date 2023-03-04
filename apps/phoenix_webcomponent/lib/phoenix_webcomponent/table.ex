defmodule Phoenix.WebComponent.Table do
  @moduledoc """
  Render table.
  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates a table.

  ## Examples

  ```heex
  <.wc_table rows={[
    %{
      name: "Shmi Skywalker",
      portrayal: "Pernilla August (Episodes I-II)"
    },
    %{
      name: "Luke Skywalker",
      portrayal: "Mark Hamill (Episodes IV-IX, The Mandalorian, The Book of Boba Fett)"}
    ]}>
    <:col let={r} label="Name">
      <%= r.name %>
    </:col>
    <:col let={r} label="Portrayal">
      <%= r.portrayal %>
    </:col>
  </.wc_table>
  ```

  """
  @doc type: :component
  attr(:id, :any,
    default: false,
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

  attr(:rows, :list,
    default: [],
    doc: """
    table data list
    """
  )

  slot(:col,
    required: false,
    doc: """
    render a column of table.

    Example
    ```heex
    <:col let={r} label="Name">
      <%= r.name %>
    </:col>
    ```
    """
  ) do
    attr(:label, :string, doc: "table column title")
  end

  def wc_table(assigns) do
    ~H"""
    <table
      id={@id}
      class={[
        "table-fixed border-collapse border-spacing-0",
        @class,
      ]}
    >
      <thead>
        <tr class="bg-slate-100 h-[34px]">
          <th
            :for={col <- @col}
            class="px-4 py-2 slate-700 text-left font-medium"
          ><%= col.label %></th>
        </tr>
      </thead>
      <tbody>
        <tr
          :for={row <- @rows}
          class={"bg-slate-50 even:bg-white h-[40px]"}
        >
          <td
            :for={col <- @col}
            class="px-4 py-2"
          ><%= render_slot(col, row) %></td>
        </tr>
      </tbody>
    </table>
    """
  end
end

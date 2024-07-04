defmodule PhoenixDuskmoon.Table do
  @moduledoc """
  Render table.
  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates a table.

  ## Examples

  ```heex
  <.dm_table data={[
    %{
      name: "Shmi Skywalker",
      portrayal: "Pernilla August (Episodes I-II)"
    },
    %{
      name: "Luke Skywalker",
      portrayal: "Mark Hamill (Episodes IV-IX, The Mandalorian, The Book of Boba Fett)"}
    ]}
  >
    <:caption>Skywalker House</:catption>
    <:col :let={r} label="Name" label_class="text-teal-600" class="text-teal-400">
      <%= r.name %>
    </:col>
    <:col :let={r} label="Portrayal">
      <%= r.portrayal %>
    </:col>
  </.dm_table>
  ```

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

  attr(:data, :list,
    default: [],
    doc: """
    table data list
    """
  )

  attr(:stream, :boolean,
    default: false,
    doc: "stream data"
  )

  slot(:caption,
    required: false,
    doc: """
    render a caption of table.

    Example
    ```heex
    <:caption>
      Table information
    </:caption>
    ```
    """
  ) do
    attr(:id, :any, doc: "table caption id")
    attr(:class, :any, doc: "table caption class")
  end

  slot(:col,
    required: false,
    doc: """
    render a column of table.

    Example
    ```heex
    <:col :let={r} label="Name">
      <%= r.name %>
    </:col>
    ```
    """
  ) do
    attr(:label, :string, doc: "table column title")
    attr(:label_class, :any, doc: "table column title title")
    attr(:class, :any, doc: "table row column class")
  end

  def dm_table(assigns) do
    ~H"""
    <table
      role="table"
      id={@id}
      class={[
        "table table-fixed border-collapse border-spacing-0",
        @class,
      ]}
    >
      <caption
        :for={caption <- @caption}
        role="caption"
        id={Map.get(caption, :id, false)}
        class={Map.get(caption, :class, "")}
      ><%= render_slot(caption) %></caption>
      <thead role="row-group" class="hidden md:table-header-group sticky top-0">
        <tr role="row" class="bg-slate-100 h-8">
          <th
            :for={col <- @col}
            role="columnheader"
            class={[
              "font-bold",
              Map.get(col, :label_class, "")
            ]}
          ><%= col.label %></th>
        </tr>
      </thead>
      <%= if @stream do %>
        <tbody role="row-group" id={"@id-stream-body"} phx-update="stream">
          <tr
            :for={{row_id, row} <- @data}
            role="row"
            id={row_id}
            class={"bg-slate-50 even:bg-white h-8"}
          >
            <td
              :for={col <- @col}
              data-label={col.label}
              role="cell"
              class={[
                "px-4 py-2",
                "grid before:content-[attr(data-label)] before:font-bold grid-cols-[6em_auto] gap-x-2 gap-y-4",
                "md:table-cell md:before:hidden",
                Map.get(col, :class, "")
              ]}
            ><%= render_slot(col, row) %></td>
          </tr>
        </tbody>
      <% else %>
        <tbody role="row-group">
          <tr
            :for={row <- @data}
            role="row"
            class={"bg-base-200 even:bg-base-100"}
          >
            <td
              :for={col <- @col}
              data-label={col.label}
              role="cell"
              class={[
                "px-4 py-2",
                "grid before:content-[attr(data-label)] before:font-bold grid-cols-[6em_auto] gap-x-2 gap-y-4",
                "md:table-cell md:before:hidden",
                Map.get(col, :class, "")
              ]}
            ><%= render_slot(col, row) %></td>
          </tr>
        </tbody>
      <%  end %>
    </table>
    """
  end
end

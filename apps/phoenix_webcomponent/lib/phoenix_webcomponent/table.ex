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
  )

  def wc_table(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:col, fn -> [] end)
      |> assign_new(:rows, fn -> [] end)

    ~H"""
    <table id={@id} class={"table-fixed border-collapse border-spacing-0 #{@class}"}>
      <thead>
        <tr class="bg-slate-100 h-[34px]">
          <%= for col <- @col do %>
            <th class=" px-4 py-2 slate-700 text-left font-medium"><%= col.label %></th>
          <% end %>
        </tr>
      </thead>
      <tbody>
      <%= for row <- @rows do %>
        <tr class="bg-slate-50 even:bg-white h-[40px]">
          <%= for col <- @col do %>
            <td class=" px-4 py-2"><%= render_slot(col, row) %></td>
          <% end %>
        </tr>
      <% end %>
      </tbody>
    </table>
    """
  end
end

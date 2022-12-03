defmodule Phoenix.WebComponent.Table do
  @moduledoc """
  Render table.
  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates a table.
  ## Examples

      <.wc_table rows={[
        %{
          name: "Shmi Skywalker",
          portrayal: "Pernilla August (Episodes I-II)\nVoice: Pernilla August (The Clone Wars)\n"
        },
        %{
          name: "Luke Skywalker",
          portrayal: "Mark Hamill (Episodes IV-IX, The Mandalorian, The Book of Boba Fett), Aidan Barton (Episode III), Grant Feely (Obi-Wan Kenobi)\nBody Doubles: Lukaz Leong (Episode IX), Max Lloyd-Jones (The Mandalorian), Graham Hamilton (The Book of Boba Fett)\n\nVoice: Mark Hamill (Forces of Destiny)\n"}
        ]}>
        <:col let={r} label="Name">
          <%= r.name %>
        </:col>
        <:col let={r} label="Portrayal">
          <%= r.portrayal %>
        </:col>
      </.wc_table>

  ## Attributes

    * `id` - `binary`
    html attribute id

    * `class` - `binary`
    html attribute class

    * `rows` - `list`
    table data, data shape is a list of map

  ## Slots

    * `col`
    Each slot for render a column.

      ### Attributes

        * `label` - `binatry`
        Render table column title line.

  """
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

defmodule Phoenix.WebComponent.Table do
  @moduledoc """
  Render table.

  """
  use Phoenix.WebComponent, :component

  @doc """
  Generates a table.

  ## Examples

  ## Options

  """
  def wc_table(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:col, fn -> [] end)
      |> assign_new(:rows, fn -> [] end)

    ~H"""
    <table class="table-fixed border-collapse border-spacing-0 border border-slate-400">
      <thead>
        <tr>
          <%= for col <- @col do %>
            <th class="border border-slate-400 px-4 py-2 slate-700"><%= col.label %></th>
          <% end %>
        </tr>
      </thead>
      <tbody>
      <%= for row <- @rows do %>
        <tr>
          <%= for col <- @col do %>
            <td class="border border-slate-400 px-4 py-2"><%= render_slot(col, row) %></td>
          <% end %>
        </tr>
      <% end %>
      </tbody>
    </table>
    """
  end
end

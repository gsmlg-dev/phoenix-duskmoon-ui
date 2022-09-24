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

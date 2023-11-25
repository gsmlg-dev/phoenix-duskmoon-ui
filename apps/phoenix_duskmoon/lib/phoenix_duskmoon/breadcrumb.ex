defmodule PhoenixDuskmoon.Breadcrumb do
  @moduledoc """
  render appbar

  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates webcomponent breadcrumb
  ## Example
      <.dm_breadcrumb>
        <:crumb>Menu1</:crumb>
        <:crumb>Menu2</:crumb>
      </.dm_breadcrumb>
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

  slot(:icon,
    required: false,
    doc: """
    Render Icon
    """
  )

  slot(:crumb,
    required: true,
    doc: """
    Render menu
    """
  ) do
    attr(:id, :any)
    attr(:class, :string)
    attr(:to, :string)
  end

  def dm_breadcrumb(assigns) do
    ~H"""
    <div id={@id} class={[
      "breadcrumbs",
      @class,
    ]}>
      <%= if length(@icon) > 0 do %>
        <%= render_slot(@icon) %>
      <% else %>
        <PhoenixDuskmoon.Icons.dm_mdi name="home" class="w-4 h-4" />
      <% end %>
      <ul>
        <li><a>Home</a></li>
        <li><a>Documents</a></li>
        <li>Add Document</li>
      </ul>
      <%= for {crumb, i} <- Enum.with_index(@crumb) do %>
      <span class="flex flex-row">
        <%= render_slot(crumb) %>
      </span>
      <%= if i + 1 < length(@crumb) do %>
      <span class="flex flex-row">
        /
      </span>
      <% end %>
      <% end %>
    </div>
    """
  end
end

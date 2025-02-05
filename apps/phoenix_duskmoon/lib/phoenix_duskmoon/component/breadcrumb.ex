defmodule PhoenixDuskmoon.Component.Breadcrumb do
  @moduledoc """
  Duskmoon UI Breadcrumb Component

  """
  use PhoenixDuskmoon.Component, :html

  @doc """
  Generates breadcrumbs for navigation.

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
    <div
      id={@id}
      class={[
        "breadcrumbs",
        @class,
      ]}
    >
      <ul>
        <li :for={crumb <- @crumb} class={Map.get(crumb, :class, nil)}>
          <%= render_slot(crumb) %>
        </li>
      </ul>
    </div>
    """
  end
end

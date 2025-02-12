defmodule PhoenixDuskmoon.Component.Navbar do
  @moduledoc """
  Duskmoon UI Navbar Component

  """
  use PhoenixDuskmoon.Component, :html

  # import PhoenixDuskmoon.Component.Link
  # import PhoenixDuskmoon.Component.Icons

  @doc """
  Generates a navbar.

  ## Example

      <.dm_navbar>
      </.dm_navbar>

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

  attr(:start_class, :any,
    default: "",
    doc: """
    Navbar left part container class
    """
  )

  attr(:center_class, :any,
    default: "",
    doc: """
    Navbar center part container class
    """
  )

  attr(:end_class, :any,
    default: "",
    doc: """
    Navbar right part container class
    """
  )

  slot(:start_part,
    required: false,
    doc: """
    Navbar left part
    """
  )

  slot(:center_part,
    required: false,
    doc: """
    Navbar center part
    """
  )

  slot(:end_part,
    required: false,
    doc: """
    Navbar right part
    """
  )

  def dm_navbar(assigns) do
    assigns =
      assigns
      |> assign_new(:logo, fn -> [] end)
      |> assign_new(:user_profile, fn -> [] end)

    ~H"""
    <div id={@id} class={["navbar", @class]}>
      <div class={["navbar-start", @start_class]}>
        <%= render_slot(@start_part) %>
      </div>
      <div class={["navbar-center", @center_class]}>
        <%= render_slot(@center_part) %>
      </div>
      <div class={["navbar-end", @end_class]}>
        <%= render_slot(@end_part) %>
      </div>
    </div>
    """
  end
end

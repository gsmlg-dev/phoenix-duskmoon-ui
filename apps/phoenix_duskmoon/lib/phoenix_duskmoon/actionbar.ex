defmodule PhoenixDuskmoon.Actionbar do
  @moduledoc """
  Render actionbar.
  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates a actionbar.

  ## Examples

  ```heex
  <.dm_actionbar class="shadow">
    <:left>
      Star Wars
    </:left>
    <:right>
      <button>action</button>
    </:right>
  </.dm_actionbar>
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

  slot(:left,
    required: false,
    doc: """
    Left part of action bar.
    """
  )

  slot(:right,
    required: false,
    doc: """
    Right part of action bar.
    """
  )

  def dm_actionbar(assigns) do
    assigns =
      assigns
      |> assign_new(:left, fn -> [] end)
      |> assign_new(:right, fn -> [] end)

    ~H"""
    <div
      id={@id}
      class={[
        "w-full h-16 px-4",
        "flex justify-between items-center",
        @class,
      ]}
    >
      <div classs="flex justify-start items-center">
        <%= render_slot(@left) %>
      </div>
      <div classs="flex justify-end items-center">
        <%= render_slot(@right) %>
      </div>
    </div>
    """
  end
end

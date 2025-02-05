defmodule PhoenixDuskmoon.Component.Actionbar do
  @moduledoc """
  Duskmoon UI Actionbar Component
  """
  use PhoenixDuskmoon.Component, :html

  @doc """
  Generates a actionbar.

  ## Examples

  ```heex
  <.dm_actionbar class="shadow">
    <:left>
      Star Wars
    </:left>
    <:right>
      <button>open</button>
    </:right>
    <:right>
      <button>show</button>
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

  attr(:left_class, :any,
    default: "",
    doc: """
    left part html attribute class
    """
  )

  attr(:right_class, :any,
    default: "",
    doc: """
    right part html attribute class
    """
  )

  slot(:left,
    required: false,
    doc: """
    Left part of action bar.
    """
  ) do
    attr(:id, :any)
    attr(:class, :any)
  end

  slot(:right,
    required: false,
    doc: """
    Right part of action bar.
    """
  ) do
    attr(:id, :any)
    attr(:class, :any)
  end

  def dm_actionbar(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "w-full h-16 px-4",
        "flex justify-between items-center",
        @class,
      ]}
    >
      <div classs={["flex justify-start items-center", @left_class]}>
        <div
          :for={left <- @left}
          id={Map.get(left, :id, false)}
          class={Map.get(left, :class, "")}
        >
          <%= render_slot(left) %>
        </div>
      </div>
      <div classs={["flex justify-end items-center", @right_class]}>
        <div
          :for={right <- @right}
          id={Map.get(right, :id, false)}
          class={Map.get(right, :class, "")}
        >
          <%= render_slot(right) %>
        </div>
      </div>
    </div>
    """
  end
end

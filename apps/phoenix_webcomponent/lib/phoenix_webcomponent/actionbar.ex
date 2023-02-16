defmodule Phoenix.WebComponent.Actionbar do
  @moduledoc """
  Render actionbar.
  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates a actionbar.

  ## Examples

  ```heex
  <.wc_actionbar class="shadow">
    <:left>
      Star Wars
    </:left>
    <:right>
      <button>action</button>
    </:right>
  </.wc_actionbar>
  ```

  """
  @doc type: :component
  attr(:id, :any,
    default: false,
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

  def wc_actionbar(assigns) do
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

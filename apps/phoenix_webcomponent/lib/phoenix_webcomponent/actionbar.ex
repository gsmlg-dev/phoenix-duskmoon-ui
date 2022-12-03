defmodule Phoenix.WebComponent.Actionbar do
  @moduledoc """
  Render actionbar.
  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates a actionbar.

  ## Examples

      <.wc_actionbar class="shadow">
        <:left>
          Star Wars
        </:left>
        <:right>
          <button>action</button>
        </:right>
      </.wc_actionbar>

  ## Attributes

  * `id` - `binary`
  html attribute id

  * `class` - `binary`
  html attribute class

  ## Slots

  * `left`
  Left part of action bar.

  * `right`
  Right part of action bar.

  """
  def wc_actionbar(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:left, fn -> [] end)
      |> assign_new(:right, fn -> [] end)

    ~H"""
    <div id={@id} class={"w-full h-16 px-4 flex justify-between items-center #{@class}"}>
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

defmodule PhoenixDuskmoon.ButtonGroup do
  @moduledoc """
  render toggle button group

  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates a toggle button group
  [INSERT LVATTRDOCS]

  """
  @doc type: :component

  def dm_toggle_button_group(assigns) do
    ~H"""
    <div class="btn-group btn-group-rounded btn-group-scrollable">
      <button class="btn">Primary</button>
      <button class="btn">Primary</button>
      <button class="btn">Primary</button>
      <button class="btn btn-active">Primary</button>
    </div>
    """
  end
end

defmodule PhoenixDuskmoon.Shimmer do
  @moduledoc """
  Render table.
  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates Shimmer.

  ## Examples

  ```heex

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

  def dm_shimmer(assigns) do
    ~H"""
    <div id={@id} class={["skeleton", @class]}></div>
    """
  end
end

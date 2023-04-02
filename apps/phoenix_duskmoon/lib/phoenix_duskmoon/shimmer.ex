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
    assigns = assigns |> assign(:random_inner, Enum.random(10_000..100_000))

    ~H"""
    <div id={@id} class={["shimmer-#{@random_inner}", @class]}>
    </div>
    """
  end
end

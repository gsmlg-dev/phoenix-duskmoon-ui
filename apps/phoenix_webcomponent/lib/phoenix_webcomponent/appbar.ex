defmodule Phoenix.WebComponent.Appbar do
  @moduledoc """
  render appbar

  """
  use Phoenix.WebComponent, :component

  @doc """
  Generates a html customElement appbar.

  """
  def appbar(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:debug, fn -> false end)
      |> assign_new(:class, fn -> false end)

    ~H"""
    <div>
    </div>
    """
  end
end

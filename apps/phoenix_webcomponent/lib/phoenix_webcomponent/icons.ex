defmodule Phoenix.WebComponent.Icons do
  @moduledoc """
  Render 7000+ Material Design Icons
  """
  use Phoenix.WebComponent, :html

  # alias Phoenix.LiveView.JS

  @icons File.ls!(Application.app_dir(:phoenix_webcomponent, "priv/mdi/svg"))
         |> Enum.filter(&String.ends_with?(&1, ".svg"))
         |> Enum.map(&String.trim(&1, ".svg"))
         |> Enum.sort(:asc)

  @spec mdi_icons() :: [String.t()]
  def mdi_icons(), do: @icons

  @doc """
  Render 7000+ Material Design Icons

  """
  def wc_mdi(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> false end)

    name = assigns.name

    inner_svg =
      File.read!(Application.app_dir(:phoenix_webcomponent, "priv/mdi/svg/#{name}.svg"))
      |> String.replace(~r/<svg[^>]+>/, "")
      |> String.replace("</svg>", "")

    assigns = assigns |> assign(:inner_svg, inner_svg)

    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" id={@id} class={@class} viewBox="0 0 24 24">
      <%= raw(@inner_svg) %>
    </svg>
    """
  end
end

defmodule PhoenixDuskmoon.Component.Icons do
  @moduledoc """
  Render 7000+ Material Design Icons
  """
  use PhoenixDuskmoon.Component, :html

  # alias Phoenix.LiveView.JS

  @md_icons File.ls!(Application.app_dir(:phoenix_duskmoon, "priv/mdi/svg"))
            |> Enum.filter(&String.ends_with?(&1, ".svg"))
            |> Enum.map(&String.trim(&1, ".svg"))
            |> Enum.sort(:asc)

  @doc """
  Return all names of available Material Design Icons.
  Can be found at [Material Design Icons](https://duskmoon-storybook.gsmlg.dev/mdi)

      > PhoenixDuskmoon.Component.Icons.mdi_icons()
        #=> [
        #=>   "abacus.svg",
        #=>   "abjad-arabic.svg",
        #=>   ...
        #=> ]
  """
  @spec mdi_icons() :: [String.t()]
  def mdi_icons(), do: @md_icons

  @doc """
  Render Material Design Icons

  ## Examples

      <.dm_mdi name="abacus" id="mdi-abjad-arabic" class="w-16 h-16" />
      #=> <svg xmlns="http://www.w3.org/2000/svg" id="mdi-abjad-arabic" class="w-16 h-16" fill="currentcolor" viewBox="0 0 24 24"><path d="M12 4C10.08 4 8.5 5.58 8.5 7.5C8.5 8.43 8.88 9.28 9.5 9.91C7.97 10.91 7 12.62 7 14.5C7 17.53 9.47 20 12.5 20C14.26 20 16 19.54 17.5 18.66L16.5 16.93C15.28 17.63 13.9 18 12.5 18C10.56 18 9 16.45 9 14.5C9 12.91 10.06 11.53 11.59 11.12L16.8 9.72L16.28 7.79L11.83 9C11.08 8.9 10.5 8.28 10.5 7.5C10.5 6.66 11.16 6 12 6C12.26 6 12.5 6.07 12.75 6.2L13.75 4.47C13.22 4.16 12.61 4 12 4Z" /></svg>

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

  attr(:name, :string,
    required: true,
    doc: """
    material icon name, avaliable names are return value of `mdi_icons()`.
    """
  )

  attr(:color, :string,
    default: "currentcolor",
    doc: """
    icon color
    """
  )

  def dm_mdi(assigns) do
    name = assigns.name

    inner_svg =
      File.read!(Application.app_dir(:phoenix_duskmoon, "priv/mdi/svg/#{name}.svg"))
      |> String.replace(~r/<svg[^>]+>/, "")
      |> String.replace("</svg>", "")

    assigns = assigns |> assign(:inner_svg, inner_svg)

    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" id={@id} class={@class} fill={@color} viewBox="0 0 24 24">
      <%= raw(@inner_svg) %>
    </svg>
    """
  end

  @bs_icons File.ls!(Application.app_dir(:phoenix_duskmoon, "priv/bsi/svg"))
            |> Enum.filter(&String.ends_with?(&1, ".svg"))
            |> Enum.map(&String.trim(&1, ".svg"))
            |> Enum.sort(:asc)

  @doc """
  Return all names of available Bootstrap Icons.
  Can be found at [Bootstrap Icons](https://duskmoon-storybook.gsmlg.dev/bsi)

      > PhoenixDuskmoon.Component.Icons.bsi_icons()
        #=> [
          "0-circle-fill.svg",
          "0-circle.svg",
          ...
        ]
  """
  @spec bsi_icons() :: [String.t()]
  def bsi_icons(), do: @bs_icons

  @doc """
  Render Bootstrap Icons

  ## Examples

      <.dm_bsi name="0-circle" class="w-16 h-16" />
      #=> <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="w-16 h-16" viewBox="0 0 16 16">
      #=>   <path d="M7.988 12.158c-1.851 0-2.941-1.57-2.941-3.99V7.84c0-2.408 1.101-3.996 2.965-3.996 1.857 0 2.935 1.57 2.935 3.996v.328c0 2.408-1.101 3.99-2.959 3.99ZM8 4.951c-1.008 0-1.629 1.09-1.629 2.895v.31c0 1.81.627 2.895 1.629 2.895s1.623-1.09 1.623-2.895v-.31c0-1.8-.621-2.895-1.623-2.895Z"/>
      #=>   <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0ZM1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8Z"/>
      #=> </svg>

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

  attr(:name, :string,
    required: true,
    doc: """
    bootstrap icon name, avaliable names are return value of `bsi_icons()`.
    """
  )

  attr(:color, :string,
    default: "currentcolor",
    doc: """
    icon color
    """
  )

  def dm_bsi(assigns) do
    name = assigns.name

    inner_svg =
      File.read!(Application.app_dir(:phoenix_duskmoon, "priv/bsi/svg/#{name}.svg"))
      |> String.replace(~r/<svg[^>]+>/, "")
      |> String.replace("</svg>", "")

    assigns = assigns |> assign(:inner_svg, inner_svg)

    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" id={@id} class={@class} fill={@color} viewBox="0 0 16 16">
      <%= raw(@inner_svg) %>
    </svg>
    """
  end
end

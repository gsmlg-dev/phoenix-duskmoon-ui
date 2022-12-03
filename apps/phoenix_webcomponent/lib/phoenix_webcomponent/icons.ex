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

  @doc """
  Return all names of available icons.
  Can be found at [Material Icons](https://phoenix-webcomponent.gsmlg.org/mdi)

      > Phoenix.WebComponent.Icons()
        #=> [
          "abacus.svg",
          "abjad-arabic.svg",
          ...
        ]
  """
  @spec mdi_icons() :: [String.t()]
  def mdi_icons(), do: @icons

  @doc """
  Render Material Design Icons

  ## Examples

      <.wc_mdi name="abacus" id="mdi-abjad-arabic" class="w-16 h-16" />
      #=> <svg xmlns="http://www.w3.org/2000/svg" id="mdi-abjad-arabic" class="w-16 h-16" fill="currentcolor" viewBox="0 0 24 24"><path d="M12 4C10.08 4 8.5 5.58 8.5 7.5C8.5 8.43 8.88 9.28 9.5 9.91C7.97 10.91 7 12.62 7 14.5C7 17.53 9.47 20 12.5 20C14.26 20 16 19.54 17.5 18.66L16.5 16.93C15.28 17.63 13.9 18 12.5 18C10.56 18 9 16.45 9 14.5C9 12.91 10.06 11.53 11.59 11.12L16.8 9.72L16.28 7.79L11.83 9C11.08 8.9 10.5 8.28 10.5 7.5C10.5 6.66 11.16 6 12 6C12.26 6 12.5 6.07 12.75 6.2L13.75 4.47C13.22 4.16 12.61 4 12 4Z" /></svg>

  """
  @doc type: :component
  attr(:id, :string,
    default: "",
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

  def wc_mdi(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> false end)
      |> assign_new(:color, fn -> "currentcolor" end)

    name = assigns.name

    inner_svg =
      File.read!(Application.app_dir(:phoenix_webcomponent, "priv/mdi/svg/#{name}.svg"))
      |> String.replace(~r/<svg[^>]+>/, "")
      |> String.replace("</svg>", "")

    assigns = assigns |> assign(:inner_svg, inner_svg)

    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" id={@id} class={@class} fill={@color} viewBox="0 0 24 24">
      <%= raw(@inner_svg) %>
    </svg>
    """
  end
end

defmodule Phoenix.WebComponent.Appbar do
  @moduledoc """
  render appbar

  """
  use Phoenix.WebComponent, :component

  import Phoenix.WebComponent.Helpers.Link

  @doc """
  Generates a html customElement appbar.

  ## Attributes

  - `title` binary
  example: "App Title"
  - `menus` List
  example: [ %{ label: "Menu Name", to: Routes.index_path(@conn, :index) } ]

  ## Slots

  - `logo`
  - `user_profile`

  """
  def wc_appbar(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:logo, fn -> [] end)
      |> assign_new(:title, fn -> "GSMLG Title" end)
      |> assign_new(:menus, fn -> [] end)
      |> assign_new(:user_profile, fn -> [] end)

    ~H"""
    <app-bar id={@id} class={@class} app-name={@title}>
        <nav slot="logo" class="flex justify-center">
        <%= render_slot(@logo) %>
        </nav>
        <%= for menu <- @menus do %>
        <%= wc_link menu.label, to: menu.to, slot: "nav" %>
        <% end %>
        <span slot="user">
        <%= render_slot(@user_profile) %>
        </span>
    </app-bar>
    """
  end
end

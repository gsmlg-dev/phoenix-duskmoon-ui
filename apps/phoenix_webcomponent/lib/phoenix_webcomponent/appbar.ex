defmodule Phoenix.WebComponent.Appbar do
  @moduledoc """
  render appbar

  """
  use Phoenix.WebComponent, :component

  import Phoenix.WebComponent.Helpers.Link

  @doc """
  Generates a html customElement appbar.

  """
  def wc_appbar(assigns) do
    assigns =
      assigns
      |> assign_new(:logo, fn -> [] end)
      |> assign_new(:title, fn -> "GSMLG Title" end)
      |> assign_new(:menus, fn -> [] end)
      |> assign_new(:user_profile, fn -> [] end)

    ~H"""
    <app-bar app-name={@title}>
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

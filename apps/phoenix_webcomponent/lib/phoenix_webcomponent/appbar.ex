defmodule Phoenix.WebComponent.Appbar do
  @moduledoc """
  render appbar

  """
  use Phoenix.WebComponent, :html

  import Phoenix.WebComponent.Link

  @doc """
  Generates a html customElement appbar.

  ## Example

      <.wc_appbar
        title={"Phoenix WebComponent"}
        menus={[
          %{ label: "Component Storybook", to: Routes.live_storybook_path(@conn, :root) }
        ]}
      >
        <:logo>
          <logo-gsmlg-dev />
        </:logo>
        <:user_profile>
          (^_^)
        </:user_profile>
      </.wc_appbar>

  ## Attributes

  * `id` - `binary`
  html attribute id

  * `class` - `binary`
  html attribute class

  * `title` - `binary`
  Appbar Title.
  example: "App Title"

  * `menus` - `List`
  Appbar menus.
  example: [ %{ label: "Menu Name", to: ~p"/menu-url" } ]

  ## Slots

  * `logo`
  Appbar Logo.

  * `user_profile`
  Right side userinfo.

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
        <.wc_link
          navigate={menu.to}
          slot="nav"
        >
          <%= menu.label %>
        </.wc_link>
      <% end %>
      <span slot="user">
        <%= render_slot(@user_profile) %>
      </span>
    </app-bar>
    """
  end

  @doc """
  Generates an simple html appbar.

  ## Example

      <.wc_simple_appbar
        title={"Phoenix WebComponent"}
        menus={[
          %{ label: "Component Storybook", to: Routes.live_storybook_path(@conn, :root) }
        ]}
      >
        <:logo>
          <logo-gsmlg-dev />
        </:logo>
        <:user_profile>
          (^_^)
        </:user_profile>
      </.wc_simple_appbar>

  ## Attributes

  * `id` - `binary`
  html attribute id

  * `class` - `binary`
  html attribute class

  * `home` - `binary`
  Link to Home page.
  example: "https://hexdocs.pm/phoenix_webcomponent/"

  * `title` - `binary`
  Appbar Title.
  example: "App Title"

  * `menus` - `List`
  Appbar menus.
  example: [ %{ label: "Menu Name", to: ~p"/menu-url" } ]

  ## Slots

  - `logo`
  Appbar Logo.

  - `user_profile`
  Right side userinfo.

  """
  def wc_simple_appbar(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:logo, fn -> [] end)
      |> assign_new(:home, fn -> nil end)
      |> assign_new(:title, fn -> "GSMLG Title" end)
      |> assign_new(:menus, fn -> [] end)
      |> assign_new(:user_profile, fn -> [] end)

    ~H"""
    <header
      class={"h-14 w-screen bg-sky-900 text-white text-xl flex items-center justify-center relative #{@class}"}
    >
      <div class="container h-full flex items-center justify-between select-none ">
        <div class="flex flex-row items-center justify-start">
          <a href={@home}>
            <%= render_slot(@logo) %>
          </a>
          <h1 class="select-none text-blod hidden lg:inline-flex">
            <a href={@home}><%= @title %></a>
          </h1>
          <nav class="text-fuchsia-200 mx-12 hidden md:flex flex-row items-center gap-4">
            <%= for menu <- @menus do %>
            <a
              class="rounded-lg bg-cyan-600 hover:bg-cyan-400 py-2 px-6 text-lg font-semibold leading-6 text-center text-white active:text-white/80"
              href={menu.to}
            ><%= menu.label %></a>
            <% end %>
          </nav>
        </div>
        <div class="flex flex-row items-center justify-end">
          <div
            class="hidden md:inline-flex"
          ><%= render_slot(@user_profile) %></div>

          <button
            class="inline-flex md:hidden w-10 h-10 justify-center items-center"
            onclick="document.getElementById('header-md-menu').classList.toggle('hidden')"
          >
            <Heroicons.bars_3 class="w-8 h-8" />
          </button>
        </div>
      </div>
      <div id="header-md-menu" class="absolute z-50 top-14 w-full bg-sky-900 flex flex-col md:hidden hidden">
        <%= for menu <- @menus do %>
        <a
          class="w-full bg-cyan-600 hover:bg-cyan-400 py-2 px-6 text-lg font-semibold leading-6 text-center text-white active:text-white/80"
          href={menu.to}
        ><%= menu.label %></a>
        <% end %>
        <hr />
        <div
          class="w-full my-2 text-center flex flex-col justify-start items-center"
        ><%= render_slot(@user_profile) %></div>
      </div>
    </header>
    """
  end
end

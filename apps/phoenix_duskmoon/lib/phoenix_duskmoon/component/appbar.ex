defmodule PhoenixDuskmoon.Component.Appbar do
  @moduledoc """
  render appbar

  """
  use PhoenixDuskmoon.Component, :html

  import PhoenixDuskmoon.Component.Link
  import PhoenixDuskmoon.Component.Icons

  @doc """
  Generates a html customElement appbar.

  ## Example

      <.dm_appbar
        title={"PhoenixDuskmoon"}
      >
        <:menu to={~p"/storybook"}>
          Component Storybook
        </:menu>
        <:logo>
          <logo-gsmlg-dev />
        </:logo>
        <:user_profile>
          (^_^)
        </:user_profile>
      </.dm_appbar>

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

  attr(:title, :string,
    default: "",
    doc: """
    Appbar title.
    """
  )

  slot(:menu,
    required: false,
    doc: """
    Appbar menus
    """
  ) do
    attr(:class, :string)
    attr(:to, :string)
  end

  slot(:logo,
    required: false,
    doc: """
    Appbar Logo.
    """
  )

  slot(:user_profile,
    required: false,
    doc: """
    Appbar right side user_profile.
    """
  )

  def dm_appbar(assigns) do
    assigns =
      assigns
      |> assign_new(:logo, fn -> [] end)
      |> assign_new(:user_profile, fn -> [] end)

    ~H"""
    <app-bar id={@id} class={@class} app-name={@title}>
      <nav slot="logo" class="flex justify-center">
        <%= render_slot(@logo) %>
      </nav>
      <%= for menu <- @menu do %>
        <.dm_link
          navigate={Map.get(menu, :to, "")}
          class={Map.get(menu, :class, "")}
          slot="nav"
        >
        <%= render_slot(menu) %>
        </.dm_link>
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

      <.dm_simple_appbar
        title={"PhoenixDuskmoon"}
      >
        <:menu to={~p"/storybook"}>
          Component Storybook
        </:menu>
        <:logo>
          <logo-gsmlg-dev />
        </:logo>
        <:user_profile>
          (^_^)
        </:user_profile>
      </.dm_simple_appbar>

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

  attr(:title, :string,
    default: "",
    doc: """
    Appbar title.
    """
  )

  slot(:menu,
    required: false,
    doc: """
    Appbar menus
    """
  ) do
    attr(:class, :string)
    attr(:to, :string)
  end

  slot(:logo,
    required: false,
    doc: """
    Appbar Logo.
    """
  )

  slot(:user_profile,
    required: false,
    doc: """
    Appbar right side user_profile.
    """
  )

  def dm_simple_appbar(assigns) do
    ~H"""
    <header
      id={@id}
      class={[
        "h-14 w-full text-xl",
        "flex items-center justify-center relative",
        @class
      ]}
    >
      <div class="container h-full flex items-center justify-between select-none">
        <div class="flex flex-row items-center justify-start">
          <%= render_slot(@logo) %>
          <h1 class="select-none text-blod hidden lg:inline-flex">
            <%= @title %>
          </h1>
          <nav class="mx-12 hidden md:flex flex-row items-center gap-4">
            <%= for menu <- @menu do %>
            <a
              class={[
                "py-2 px-6",
                "text-lg font-semibold leading-6 text-center",
                "hover:opacity-50",
                Map.get(menu, :class, "")
              ]}
              href={Map.get(menu, :to, false)}
            >
              <%= render_slot(menu) %>
            </a>
            <% end %>
          </nav>
        </div>
        <div class="flex flex-row items-center justify-end">
          <div
            class="hidden md:inline-flex"
          ><%= render_slot(@user_profile) %></div>
          <button
            class={[
              "inline-flex justify-center items-center",
              "md:hidden w-10 h-10",
            ]}
            onclick="document.getElementById('header-md-menu').classList.toggle('hidden')"
          >
            <.dm_mdi name="menu" class="w-8 h-8" />
          </button>
        </div>
      </div>
      <div
        id="header-md-menu"
        class={[
          "absolute z-50 top-14 w-full",
          "flex flex-col",
          "md:hidden hidden",
          @class
        ]}
      >
        <hr />
        <%= for menu <- @menu do %>
        <a
          class={[
            "w-full py-2 px-6",
            "font-semibold leading-6",
            "text-lg text-center",
            Map.get(menu, :class, "")
          ]}
        >
          <%= render_slot(menu) %>
        </a>
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

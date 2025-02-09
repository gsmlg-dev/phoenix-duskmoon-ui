defmodule PhoenixDuskmoon.Component do
  @moduledoc """
  Provides `Duskmoon UI` component for phoenix.

  This library add a list of phoneix component.

  """

  @doc """
  Generate a random id format `random-8DFBEE211780394A`
  """

  def generate_id() do
    "random-#{:crypto.strong_rand_bytes(8) |> Base.encode16()}"
  end

  @doc false
  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  @doc false
  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS
    end
  end

  @doc false
  def component do
    quote do
      import PhoenixDuskmoon.Component.Actionbar
      import PhoenixDuskmoon.Component.Appbar
      import PhoenixDuskmoon.Component.Breadcrumb
      import PhoenixDuskmoon.Component.Button
      import PhoenixDuskmoon.Component.Card
      import PhoenixDuskmoon.Component.Form
      import PhoenixDuskmoon.Component.Flash
      import PhoenixDuskmoon.Component.Icons
      import PhoenixDuskmoon.Component.LeftMenu
      import PhoenixDuskmoon.Component.Link
      import PhoenixDuskmoon.Component.Loading
      import PhoenixDuskmoon.Component.Markdown
      import PhoenixDuskmoon.Component.Modal
      import PhoenixDuskmoon.Component.PageFooter
      import PhoenixDuskmoon.Component.PageHeader
      import PhoenixDuskmoon.Component.Pagination
      import PhoenixDuskmoon.Component.Tab
      import PhoenixDuskmoon.Component.Table
      import PhoenixDuskmoon.Component.ThemeSwitcher
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    quote do
      unquote(component())
    end
  end
end

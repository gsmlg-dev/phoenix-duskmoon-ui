defmodule PhoenixDuskmoon.Component do
  @moduledoc """
  Provides a suit of html custom component for phoenix.

  This library add a list of phoneix component.

  ## Form helper

  See `PhoenixDuskmoon.FormHelper`.

  ## JavaScript library

  This project provides javascript that define custom elements.

  To use the web component, you must load `priv/static/phoenix_duskmoon.js`
  into your build tool. Or through npm by install `phoenix_duskmoon`.

  ### Using js library in hex package:

  We need to run npm install in hex package

  ```
  npm install --prefix <path to root>/deps/phoenix/duskmoon
  ```

  """

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

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

  def component do
    quote do
      import PhoenixDuskmoon.Component.Actionbar
      import PhoenixDuskmoon.Component.Appbar
      import PhoenixDuskmoon.Component.Breadcrumb
      import PhoenixDuskmoon.Component.Card
      import PhoenixDuskmoon.Component.Icons
      import PhoenixDuskmoon.Component.LeftMenu
      import PhoenixDuskmoon.Component.Link
      import PhoenixDuskmoon.Component.Loading
      import PhoenixDuskmoon.Component.Markdown
      import PhoenixDuskmoon.Component.Modal
      import PhoenixDuskmoon.Component.Pagination
      import PhoenixDuskmoon.Component.PageHeader
      import PhoenixDuskmoon.Component.PageFooter
      import PhoenixDuskmoon.Component.Tab
      import PhoenixDuskmoon.Component.Table
      import PhoenixDuskmoon.Component.Form
    end
  end

  @doc """
  Import helpers for internal usage.

  ## Support:

  - `use PhoenixDuskmoon`

  ### Internal use Only

  - `use PhoenixDuskmoon.Component`
  - `use PhoenixDuskmoon.Component, :live_component`

  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    quote do
      unquote(component())
    end
  end
end

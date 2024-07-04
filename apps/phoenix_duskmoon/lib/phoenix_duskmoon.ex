defmodule PhoenixDuskmoon do
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

  def alias do
    quote do
      alias PhoenixDuskmoon.Link
      alias PhoenixDuskmoon.Actionbar
      alias PhoenixDuskmoon.Appbar
      alias PhoenixDuskmoon.Breadcrumb
      alias PhoenixDuskmoon.Card
      alias PhoenixDuskmoon.LeftMenu
      alias PhoenixDuskmoon.Markdown
      alias PhoenixDuskmoon.Modal
      alias PhoenixDuskmoon.Pagination
      alias PhoenixDuskmoon.Table
      alias PhoenixDuskmoon.PageHeader
      alias PhoenixDuskmoon.PageFooter
      alias PhoenixDuskmoon.Tab
      alias PhoenixDuskmoon.Form
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

  defp components do
    quote do
      import PhoenixDuskmoon.Actionbar
      import PhoenixDuskmoon.Appbar
      import PhoenixDuskmoon.Breadcrumb
      import PhoenixDuskmoon.Card
      import PhoenixDuskmoon.Icons
      import PhoenixDuskmoon.LeftMenu
      import PhoenixDuskmoon.Link
      import PhoenixDuskmoon.Loading
      import PhoenixDuskmoon.Markdown
      import PhoenixDuskmoon.Modal
      import PhoenixDuskmoon.Pagination
      import PhoenixDuskmoon.PageHeader
      import PhoenixDuskmoon.PageFooter
      import PhoenixDuskmoon.Tab
      import PhoenixDuskmoon.Table
      import PhoenixDuskmoon.Form
    end
  end

  @doc """
  Import helpers for internal usage.

  ## Support:

  - `use PhoenixDuskmoon`

  ### Internal use Only

  - `use PhoenixDuskmoon, :component`
  - `use PhoenixDuskmoon, :live_component`

  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    quote do
      unquote(components())
    end
  end
end

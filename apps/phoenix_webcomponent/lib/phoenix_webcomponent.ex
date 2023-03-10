defmodule Phoenix.WebComponent do
  @moduledoc """
  Provides a suit of html custom component for phoenix.

  This library add a list of phoneix component.

  ## Form helper

  See `Phoenix.WebComponent.FormHelper`.

  ## JavaScript library

  This project provides javascript that define custom elements.

  To use the web component, you must load `priv/static/phoenix_webcomponent.js`
  into your build tool. Or through npm by install `phoenix_webcomponent`.
  The difference is npm version is not bundled.

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
      alias Phoenix.WebComponent.Link
      alias Phoenix.WebComponent.Actionbar
      alias Phoenix.WebComponent.Appbar
      alias Phoenix.WebComponent.Breadcrumb
      alias Phoenix.WebComponent.Card
      alias Phoenix.WebComponent.LeftMenu
      alias Phoenix.WebComponent.Markdown
      alias Phoenix.WebComponent.Modal
      alias Phoenix.WebComponent.Pagination
      alias Phoenix.WebComponent.Table
      alias Phoenix.WebComponent.PageHeader
      alias Phoenix.WebComponent.PageFooter
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
      import Phoenix.WebComponent.Link
      import Phoenix.WebComponent.Actionbar
      import Phoenix.WebComponent.Appbar
      import Phoenix.WebComponent.Breadcrumb
      import Phoenix.WebComponent.Card
      import Phoenix.WebComponent.LeftMenu
      import Phoenix.WebComponent.Markdown
      import Phoenix.WebComponent.Modal
      import Phoenix.WebComponent.Pagination
      import Phoenix.WebComponent.Table
      import Phoenix.WebComponent.Icons
      import Phoenix.WebComponent.PageHeader
      import Phoenix.WebComponent.PageFooter
    end
  end

  @doc """
  Import helpers for internal usage.

  ## Support:

  - `use Phoenix.WebComponent`

  ### Internal use Only

  - `use Phoenix.WebComponent, :component`
  - `use Phoenix.WebComponent, :live_component`

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

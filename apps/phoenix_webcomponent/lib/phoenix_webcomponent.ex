defmodule Phoenix.WebComponent do
  @moduledoc """
  Provides a suit of html custom component for phoenix.

  This library provides three main functionalities:

    * Enhance form helper with manterial web componet
    * Enhance link helper with manterial web componet
    * Markdown render helper with `@gsmlg/lit/remark-element`
    * TopAppBar render top app bar with custom element.

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

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View
    end
  end

  @doc """
  Import helpers for internal usage.

  Support:

  - `use Phoenix.WebComponent, :component`
  - `use Phoenix.WebComponent, :live_component`

  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
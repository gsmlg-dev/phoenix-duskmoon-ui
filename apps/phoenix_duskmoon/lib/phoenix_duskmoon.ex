defmodule PhoenixDuskmoon do
  @moduledoc """
  Provides Duskmoon UI for phoenix.

  Require `tailwindcss >= 4.0` and `daisyui >= 5.0`

  ## Install in deps

  Add deps in mix.exs

      {:phoenix_duskmoon, "~> 5.0"}

  ## Setup in `Phoenix` project

  - In `app_web.ex`

  ```

      defp html_helpers do
        quote do
          # import all duskmoon ui component
          use PhoenixDuskmoon.Component
          # import all duskmoon ui fun component
          use PhoenixDuskmoon.Fun
          ...
        end
      end
  ```

  - In `app.css`

  ```

      @config "../tailwind.config.js";

      @import "tailwindcss";
      @plugin "@tailwindcss/typography";
      @plugin "daisyui";
      @import "phoenix_duskmoon/theme";
      @import "phoenix_duskmoon/components";
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

  def components do
    quote do
      import PhoenixDuskmoon.Component.Actionbar
      import PhoenixDuskmoon.Component.Appbar
      import PhoenixDuskmoon.Component.Breadcrumb
      import PhoenixDuskmoon.Component.Button
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
      import PhoenixDuskmoon.Component.Flash
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
  @deprecated "Use `use PhoenixDuskmoon.Component` instead"
  defmacro __using__(_)

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    quote do
      unquote(components())
    end
  end
end

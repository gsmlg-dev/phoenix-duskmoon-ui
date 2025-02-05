defmodule PhoenixDuskmoon do
  @moduledoc """
  Provides Duskmoon UI for Phoenix project.

  Require `tailwindcss >= 4.0` and `daisyui >= 5.0`

  ## Install in deps

  Add deps in `mix.exs`

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

  ```css

      @config "../tailwind.config.js";

      @import "tailwindcss";
      @plugin "@tailwindcss/typography";
      @plugin "daisyui";
      @import "phoenix_duskmoon/theme";
      @import "phoenix_duskmoon/components";
  ```

  """
end

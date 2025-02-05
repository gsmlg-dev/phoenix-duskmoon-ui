defmodule PhoenixDuskmoon.Fun do
  @moduledoc """
  Duskmoon Fun Component

  Import in helpers

  ```

      defp html_helpers do
        quote do
          use PhoenixDuskmoon.Fun
          ...
        end
      end
  ```

  """

  @doc false
  def fun_component do
    quote do
      import PhoenixDuskmoon.Fun.Element
    end
  end

  @doc false
  defmacro __using__(_) do
    quote do
      unquote(fun_component())
    end
  end
end

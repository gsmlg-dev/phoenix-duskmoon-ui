defmodule Phoenix.WebComponentTest do
  use ExUnit.Case, async: true

  use Phoenix.WebComponent
  import Phoenix.WebComponent
  # doctest Phoenix.WebComponent

  test "link_attributes" do
    assert link_attributes({:javascript, "alert('my alert!')"}) == [
             data: [method: :get, to: ["javascript", 58, "alert('my alert!')"]]
           ]
  end
end

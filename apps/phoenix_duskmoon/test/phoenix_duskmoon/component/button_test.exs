defmodule PhoenixDuskmoon.Component.ButtonTest do
  use ExUnit.Case, async: true
  import Phoenix.Component
  import PhoenixDuskmoon.Component.Button

  defp render(heex) do
    heex
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp basic_button_template(assigns) do
    ~H[<.dm_btn>Click me</.dm_btn>]
  end

  test "renders a basic button" do
    html = basic_button_template(%{}) |> render()
    assert html =~ "<button"
    assert html =~ "Click me"
    assert html =~ "class=\"btn \""
  end

  defp confirm_button_template(assigns) do
    ~H[<.dm_btn confirm="Are you sure?">Click me</.dm_btn>]
  end

  test "renders a button with a confirm dialog" do
    html = confirm_button_template(%{}) |> render()
    assert html =~ "Click me"
    assert html =~ "Are you sure?"
    assert html =~ "<dialog"
    assert html =~ "class=\"modal\""
  end

  defp noise_button_template(assigns) do
    ~H[<.dm_btn noise={true} />]
  end

  test "renders a button with noise" do
    html = noise_button_template(%{}) |> render()
    assert html =~ "<button"
    assert html =~ "class=\"btn-noise \""
    assert html =~ "<i"
  end
end

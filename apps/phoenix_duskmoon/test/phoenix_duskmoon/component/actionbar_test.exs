defmodule PhoenixDuskmoon.Component.ActionbarTest do
  use ExUnit.Case, async: true
  import Phoenix.Component
  import PhoenixDuskmoon.Component.Actionbar

  defp render(heex) do
    heex
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp actionbar_template(assigns) do
    ~H"""
    <.dm_actionbar>
      <:left>Left content</:left>
      <:right>Right content</:right>
    </.dm_actionbar>
    """
  end

  test "renders an actionbar with left and right content" do
    html = actionbar_template(%{}) |> render()
    assert html =~ "Left content"
    assert html =~ "Right content"
  end

  defp actionbar_with_attrs_template(assigns) do
    ~H"""
    <.dm_actionbar id="my-actionbar" class="my-class" />
    """
  end

  test "renders an actionbar with id and class" do
    html = actionbar_with_attrs_template(%{}) |> render()
    assert html =~ "id=\"my-actionbar\""
    assert html =~ "class=\"w-full h-16 px-4 flex justify-between items-center my-class\""
  end

  defp actionbar_with_slot_classes_template(assigns) do
    ~H"""
    <.dm_actionbar left_class="left-extra" right_class="right-extra">
      <:left>Left</:left>
      <:right>Right</:right>
    </.dm_actionbar>
    """
  end

  test "renders an actionbar with custom slot classes" do
    html = actionbar_with_slot_classes_template(%{}) |> render()
    assert html =~ "class=\"flex justify-start items-center left-extra\""
    assert html =~ "class=\"flex justify-end items-center right-extra\""
  end

  defp actionbar_with_multiple_slots_template(assigns) do
    ~H"""
    <.dm_actionbar>
      <:left>Left 1</:left>
      <:left>Left 2</:left>
      <:right>Right 1</:right>
      <:right>Right 2</:right>
    </.dm_actionbar>
    """
  end

  test "renders an actionbar with multiple slots" do
    html = actionbar_with_multiple_slots_template(%{}) |> render()
    assert html =~ "Left 1"
    assert html =~ "Left 2"
    assert html =~ "Right 1"
    assert html =~ "Right 2"
  end
end

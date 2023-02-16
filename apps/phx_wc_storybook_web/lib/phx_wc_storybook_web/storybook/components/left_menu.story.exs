defmodule PhxWCStorybookWeb.Storybook.Components.LeftMenu do
  # :live_component or :page are also available
  use PhxLiveStorybook.Story, :component
  import Phoenix.WebComponent.LeftMenu

  def function, do: &Phoenix.WebComponent.LeftMenu.wc_left_menu/1

  def description, do: "A left menu element."

  def imports do
    [{Phoenix.WebComponent.LeftMenu, wc_left_menu_group: 1}]
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          active: "left_menu"
        },
        slots: [
          """
          <:title class="font-bold">Menu Demo</:title>
          """,
          """
          <:menu>
            <.wc_left_menu_group active={"left_menu"}>
              <:title>Hooks</:title>
              <:menu id="phx_hook" to="/">Phx Hook</:menu>
            </.wc_left_menu_group>
          </:menu>
          """,
          """
          <:menu>
            <.wc_left_menu_group active={"left_menu"}>
              <:title>Icons</:title>
              <:menu id="mdi" to="/mdi">MD Icon</:menu>
              <:menu id="msi" to="/bsi">BS Icon</:menu>
            </.wc_left_menu_group>
          </:menu>
          """,
          """
          <:menu>
            <.wc_left_menu_group active={"left_menu"}>
              <:title>Components</:title>
              <:menu id="table" to="/storybook/components/actionbar">Actionbar</:menu>
              <:menu id="card" to="/storybook/components/card">Card</:menu>
              <:menu id="left_menu" to="/storybook/components/left_menu">Left Menu</:menu>
              <:menu id="markdown" to="/storybook/components/markdown">Markdown</:menu>
              <:menu id="pagination" to="/storybook/components/pagination">Pagination</:menu>
              <:menu id="table" to="/storybook/components/table">Table</:menu>
            </.wc_left_menu_group>
          </:menu>
          """
        ]
      }
    ]
  end
end

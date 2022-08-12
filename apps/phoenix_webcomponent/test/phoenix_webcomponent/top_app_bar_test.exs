defmodule Phoenix.WebComponent.TopAppBarTest do
  use ExUnit.Case, async: true

  import Phoenix.HTML
  import Phoenix.HTML.Tag
  import Phoenix.WebComponent.TopAppBar

  test "wc_top_app_bar empty" do
    assert safe_to_string(wc_top_app_bar([], do: "")) ==
             ~s[<mwc-top-app-bar></mwc-top-app-bar>]
  end

  test "wc_top_app_bar fixed with slots" do
    assert safe_to_string(
             wc_top_app_bar(fixed: true) do
               content_tag(:"mwc-icon-button", "", icon: "menu", slot: "navigationIcon")
             end
           ) ==
             ~s[<mwc-top-app-bar-fixed><mwc-icon-button icon="menu" slot="navigationIcon"></mwc-icon-button></mwc-top-app-bar-fixed>]
  end
end

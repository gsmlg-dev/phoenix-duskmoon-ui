defmodule Phoenix.WebComponent.TopAppBar do
  @moduledoc """
  Conveniences for create top app bar.
  """

  alias Phoenix.LiveView
  import Phoenix.HTML.Tag
  import Phoenix.LiveView.Helpers

  @doc """
  Generates a top app bar.

  Or

  Top app bar component

  ## Examples

      wc_top_app_bar([fixed: true], do: "/world")
      #=> <mwc-top-app-bar-fixed>/world</mwc-top-app-bar-fixed>

  ```heex
  <.wc_top_app_bar fixed centerTitle slot="appContent" title={@page_title}>
    <mwc-icon-button icon="menu" slot="navigationIcon"></mwc-icon-button>
  </.wc_top_app_bar>
  ```

  ## Options

  ### Slots of custom element

  | Name | Description
  | ---- | -----------
  | `actionItems` | A number of `<mwc-icon-button>` elements to use for action icons on the right side. _NOTE:_ If using with `mwc-drawer`, please read note under [`Standard` drawer example](https://github.com/material-components/material-web/tree/master/packages/top-app-bar).
  | `navigationIcon` | One `<mwc-icon-button>` element to use for the left icon.
  | `title` | A `<div>` or `<span>` that will be used as the title text.
  | _default_ | Scrollable content to display under the bar. This may be the entire application.

  ### Properties/Attributes  of custom element

  | Name | Type | Default | Description
  | ---- | ---- | ------  | -----------
  | `centerTitle` | `boolean` | `false` | Centers the title horizontally. Only meant to be used with 0 or 1 `actionItems`.
  | `dense` | `boolean` | `false` | Makes the bar a little smaller for higher density applications.
  | `prominent` | `boolean` | `false` | Makes the bar much taller, can be combined with `dense`.
  | `scrollTarget` | `HTMLElement` | `Window` | `window` | Element used to listen for `scroll` events.

  ### Elixir options

  | Name | Type | Default | Description
  | ---- | ---- | ------- | -----------
  | `title` | binatry | nil | Put content in title slot

  """
  def wc_top_app_bar(opts, do: contents) when is_list(opts) do
    {fixed, opts} = Keyword.pop(opts, :fixed, false)
    app_bar_tag = if fixed, do: :"mwc-top-app-bar-fixed", else: :"mwc-top-app-bar"
    {title, opts} = Keyword.pop(opts, :title)

    content_tag(app_bar_tag, opts) do
      if is_nil(title) do
        contents
      else
        [content_tag(:div, title, class: "app-bar-title", slot: "title"), contents]
      end
    end
  end

  def wc_top_app_bar(assigns) do
    fixed = assigns[:fixed] || false
    title = assigns[:title] || nil

    attrs = assigns_to_attributes(assigns, [:fixed, :title])

    assigns = LiveView.assign(assigns, fixed: fixed, title: title, attrs: attrs)

    ~H"""
    <%= if @fixed do %>
      <mwc-top-app-bar-fixed {@attrs}>
        <%= if @title do %>
        <div class="app-bar-title" slot="title">
          <%= @title %>
        </div>
        <% end %>
        <%= render_slot(@inner_block) %>
      </mwc-top-app-bar-fixed>
    <% else %>
      <mwc-top-app-bar {@attrs}>
        <%= if @title do %>
        <div class="app-bar-title" slot="title">
          <%= @title %>
        </div>
        <% end %>
        <%= render_slot(@inner_block) %>
      </mwc-top-app-bar>
    <% end %>
    """
  end
end

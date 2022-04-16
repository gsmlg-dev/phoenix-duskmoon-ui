defmodule Phoenix.WebComponent.TopAppBar do
  @moduledoc """
  Conveniences for create top app bar.
  """

  import Phoenix.HTML.Tag

  @doc """
  Generates a top app bar.

  ## Examples

      wc_top_app_bar([fixed: true], do: "/world")
      #=> <mwc-top-app-bar-fixed>/world</mwc-top-app-bar-fixed>

  ## Options

  ### Slots

  | Name | Description
  | ---- | -----------
  | `actionItems` | A number of `<mwc-icon-button>` elements to use for action icons on the right side. _NOTE:_ If using with `mwc-drawer`, please read note under [`Standard` drawer example](https://github.com/material-components/material-web/tree/master/packages/top-app-bar).
  | `navigationIcon` | One `<mwc-icon-button>` element to use for the left icon.
  | `title` | A `<div>` or `<span>` that will be used as the title text.
  | _default_ | Scrollable content to display under the bar. This may be the entire application.

  ### Properties/Attributes

  | Name | Type | Default | Description
  | ---- | ---- | ------- | -----------
  | `centerTitle` | `boolean` | `false` | Centers the title horizontally. Only meant to be used with 0 or 1 `actionItems`.
  | `dense` | `boolean` | `false` | Makes the bar a little smaller for higher density applications.
  | `prominent` | `boolean` | `false` | Makes the bar much taller, can be combined with `dense`.
  | `scrollTarget` | `HTMLElement` | `Window` | `window` | Element used to listen for `scroll` events.

  """
  def wc_top_app_bar(opts, do: contents) when is_list(opts) do
    {fixed, opts} = Keyword.pop(opts, :fixed, false)
    app_bar_tag = if fixed, do: :"mwc-top-app-bar-fixed", else: :"mwc-top-app-bar"

    content_tag(app_bar_tag, opts) do
      contents
    end
  end
end

# Phoenix.WebComponent

[![release](https://github.com/gsmlg-dev/phoenix_webcomponent/actions/workflows/test-and-release.yml/badge.svg)](https://github.com/gsmlg-dev/phoenix_webcomponent/actions/workflows/test-and-release.yml)

Collection of helpers to generate and manipulate Web Component.

Although this project was originally extracted from Phoenix,
it does not depend on Phoenix and can be used with any Plug
application (or even without Plug).

See the [docs](https://hexdocs.pm/phoenix_webcomponent/) for more information.

About at [Web Component](https://developer.mozilla.org/en-US/docs/Web/Web_Components)

## Install

Add deps in `mix.exs`
```elixir
    {:phoenix_webcomponent, "~> 1.0"},
```

Include in phoenix view helpers

```elixir
 defp view_helpers do
    quote do
        # Use all HTML functionality (forms, tags, etc)
        use Phoenix.HTML
        use Phoenix.WebComponent

        ...
    end
end
```

Include javascript

```javascript
import 'phoenix_webcomponent';
```

By default, javascirpt is at `priv/static/phoenix_webcomponent.js` and bundle all packages.

If you wannt better javascript bundle, you can use npm version.

```bash
npm install phoenix_webcomponent
```

### All helpers

- wc_button
- wc_checkbox
- wc_color_input
- wc_date_input
- wc_date_select
- wc_datetime_local_input
- wc_datetime_select
- wc_email_input
- wc_file_input
- wc_link
- wc_live_patch
- wc_live_redirect
- wc_multiple_select
- wc_number_input
- wc_password_input
- wc_radio_button
- wc_range_input
- wc_remark
- wc_reset
- wc_search_input
- wc_select
- wc_submit
- wc_telephone_input
- wc_textarea
- wc_text_input
- wc_time_input
- wc_time_select
- wc_url_input


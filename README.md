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
    {:phoenix_webcomponent, "~> 2.0"},
```

Include in phoenix view helpers

```elixir
 defp view_helpers do
    quote do
        # import all helper functions
        use Phoenix.WebComponent

        # or 
        use Phoenix.WebComponent, :alias
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

- wc_appbar
- wc_markdown
- wc_pagination
- wc_table

## Live Storybook

[Live Storybook](https://phoenix-webcomponent.gsmlg.org)



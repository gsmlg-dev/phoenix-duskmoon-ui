# PhoenixDuskmoon

[![release](https://github.com/gsmlg-dev/phoenix-duskmoon-ui/actions/workflows/test-and-release.yml/badge.svg)](https://github.com/gsmlg-dev/phoenix-duskmoon-ui/actions/workflows/test-and-release.yml)

Collection of helpers to generate and manipulate Web Component.

Although this project was originally extracted from Phoenix,
it does not depend on Phoenix and can be used with any Plug
application (or even without Plug).

See the [docs](https://hexdocs.pm/phoenix_duskmoon/) for more information.

About at [Web Component](https://developer.mozilla.org/en-US/docs/Web/Web_Components)

## Install

Add deps in `mix.exs`
```elixir
    {:phoenix_duskmoon, "~> 3.0"},
```

Include in phoenix view helpers

```elixir
 defp html_helpers do
    quote do
        # import all helper functions
        use PhoenixDuskmoon

        # or 
        use PhoenixDuskmoon, :alias
        ...
    end
end
```

Include `javascript`

```javascript
import 'phoenix_duskmoon';
```

Web Componet library is now external

```bash
npm install @gsmlg/lit
```

Import `css`

```css
@import 'phoenix_duskmoon/priv/static/phoenix_duskmoon.css';
```

Use custom hook

```javascript
import "phoenix_duskmoon";
const WebComponentHook = window.__WebComponentHook__;
const liveSocket = new LiveSocket("/live", Socket, {hooks: { WebComponentHook }});
```

Send custom events to live view:
```html
<Element darkmoon-send-sync-content="load_content" phx-hook="WebComponentHook" />
<Element darkmoon-send-sync-content="load_content;loadAccepted" phx-hook="WebComponentHook" />
```
- In the first element, when element trigger customEvents `sync-content`, also use `pushEvent` send `load_content` to live view.
- Second element are same as first, but will call `loadAccepted` on element when receive server send feedback.

Receive live view event:
```html
<Element darkmoon-receive-update_content="updateContent" phx-hook="WebComponentHook" />
<!-- equal  -->
<Element darkmoon-receive="update_content;updateContent" phx-hook="WebComponentHook" />
```
- In this case, when live view fire `update_content` event, also trigger `updateContent` method on elmenet.
- If value(`updateContent`) is empty, trigger a same event `update_content` on element.

Import CSS

```css
import "phoenix_duskmoon/priv/static/phoenix_duskmoon.css"
```

## Live Storybook

[Live Storybook](https://duskmoon-storybook.gsmlg.dev)

![](screenshots/1.png)
![](screenshots/2.png)
![](screenshots/3.png)
![](screenshots/4.png)

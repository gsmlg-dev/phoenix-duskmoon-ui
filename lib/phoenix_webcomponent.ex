defmodule Phoenix.WebComponent do
  @moduledoc """
  The default building blocks for working with HTML safely
  in Phoenix.

  This library provides three main functionalities:

    * Form handling (with CSRF protection)
    * A tiny JavaScript library to enhance applications

  ## Form handling

  See `Phoenix.WebComponent.Form`.

  ## JavaScript library

  This project ships with a tiny bit of JavaScript that listens
  to all click events to:

    * Support `data-confirm="message"` attributes, which shows
      a confirmation modal with the given message

    * Support `data-method="patch|post|put|delete"` attributes,
      which sends the current click as a PATCH/POST/PUT/DELETE
      HTTP request. You will need to add `data-to` with the URL
      and `data-csrf` with the CSRF token value. See
      `link_attributes/2` for a function that wraps it all up
      for you

    * Dispatch a "phoenix.link.click" event. You can listen to this
      event to customize the behaviour above. Returning false from
      this event will disable `data-method`. Stopping propagation
      will disable `data-confirm`

  To use the functionality above, you must load `priv/static/phoenix_html.js`
  into your build tool.

  ### Overriding the default confirm behaviour

  You can override the default confirmation behaviour by hooking
  into `phoenix.link.click`. Here is an example:

  ```javascript
  // listen on document.body, so it's executed before the default of
  // phoenix_html, which is listening on the window object
  document.body.addEventListener('phoenix.link.click', function (e) {
    // Prevent default implementation
    e.stopPropagation();

    // Introduce alternative implementation
    var message = e.target.getAttribute("data-confirm");
    if(!message){ return true; }
    vex.dialog.confirm({
      message: message,
      callback: function (value) {
        if (value == false) { e.preventDefault(); }
      }
    })
  }, false);
  ```

  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Phoenix.WebComponent.Form
      import Phoenix.WebComponent.Link
    end
  end

end

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

  @doc """
  Returns a list of attributes that make an element behave like a link.
  For example, to make a button work like a link:
      <button {link_attributes("/home")}>
        Go back to home
      </button>
  However, this function is more often used to create buttons that
  must invoke an action on the server, such as deleting an entity,
  using the relevant HTTP protocol:
      <button data-confirm="Are you sure?" {link_attributes("/product/1", method: :delete}>
        Delete product
      </button>
  The `to` argument may be a string, a URI, or a tuple `{scheme, value}`.
  See the examples below.
  Note: using this function requires loading the JavaScript library
  at `priv/static/phoenix_html.js`. See the `Phoenix.HTML` module
  documentation for more information.
  ## Options
    * `:method` - the HTTP method for the link. Defaults to `:get`.
    * `:csrf_token` - a custom token to use when method is not `:get`.
      This is used to ensure the request was sent by the user who
      rendered the page. By default, CSRF tokens are generated through
      `Plug.CSRFProtection`. You can set this option to `false`, to
      disable token generation, or set it to your own token.
  When the `:method` is set to `:get` and the `:to` URL contains query
  parameters the generated form element will strip the parameters in
  accordance with the [W3C](https://www.w3.org/TR/html401/interact/forms.html#h-17.13.3.4)
  form specification.
  ## Data attributes
  The following data attributes can also be manually set in the element:
    * `data-confirm` - shows a confirmation prompt before generating and
      submitting the form.
  ## Examples
      iex> link_attributes("/world")
      [data: [method: :get, to: "/world"]]
      iex> link_attributes(URI.parse("https://elixir-lang.org"))
      [data: [method: :get, to: "https://elixir-lang.org"]]
      iex> link_attributes("/product/1", method: :delete)
      [data: [csrf: Plug.CSRFProtection.get_csrf_token(), method: :delete, to: "/product/1"]]
  If the URL is absolute, only certain schemas are allowed to
  avoid JavaScript injection. For example, the following will fail:
      iex> link_attributes("javascript:alert('hacked!')")
      ** (ArgumentError) unsupported scheme given as link. In case you want to link to an
      unknown or unsafe scheme, such as javascript, use a tuple: {:javascript, rest}
  You can however explicitly render those unsafe schemes by using a tuple:
      iex> link_attributes({:javascript, "alert('my alert!')"})
      [data: [method: :get, to: ["javascript", 58, "alert('my alert!')"]]]
  """
  def link_attributes(to, opts \\ []) do
    to = valid_destination!(to)
    method = Keyword.get(opts, :method, :get)
    data = [method: method, to: to]

    data =
      if method == :get do
        data
      else
        case Keyword.get(opts, :csrf_token, true) do
          true -> [csrf: Phoenix.HTML.Tag.csrf_token_value(to)] ++ data
          false -> data
          csrf when is_binary(csrf) -> [csrf: csrf] ++ data
        end
      end

    [data: data]
  end

  defp valid_destination!(%URI{} = uri) do
    valid_destination!(URI.to_string(uri))
  end

  defp valid_destination!({:safe, to}) do
    {:safe, valid_string_destination!(IO.iodata_to_binary(to))}
  end

  defp valid_destination!({other, to}) when is_atom(other) do
    [Atom.to_string(other), ?:, to]
  end

  defp valid_destination!(to) do
    valid_string_destination!(IO.iodata_to_binary(to))
  end

  @valid_uri_schemes ~w(http: https: ftp: ftps: mailto: news: irc: gopher:) ++
                       ~w(nntp: feed: telnet: mms: rtsp: svn: tel: fax: xmpp:)

  for scheme <- @valid_uri_schemes do
    defp valid_string_destination!(unquote(scheme) <> _ = string), do: string
  end

  defp valid_string_destination!(to) do
    if not match?("/" <> _, to) and String.contains?(to, ":") do
      raise ArgumentError, """
      unsupported scheme given as link. In case you want to link to an
      unknown or unsafe scheme, such as javascript, use a tuple: {:javascript, rest}\
      """
    else
      to
    end
  end
end

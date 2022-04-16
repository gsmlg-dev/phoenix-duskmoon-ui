defmodule Phoenix.WebComponent do
  @moduledoc """
  Provides a suit of html custom component for phoenix.

  This library provides three main functionalities:

    * Enhance form helper with manterial web componet
    * Enhance link helper with manterial web componet
    * Markdown render helper with @gsmlg/lit/remark-element

  ## Form helper

  See `Phoenix.WebComponent.FormHelper`.

  ## JavaScript library

  This project provides javascript that define custom elements.

  To use the web component, you must load `priv/static/phoenix_webcomponent.js`
  into your build tool. Or through npm by install `phoenix_webcomponent`.
  The difference is npm version is not bundled.

  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Phoenix.WebComponent.FormHelper
      import Phoenix.WebComponent.Link
      import Phoenix.WebComponent.Markdown
      import Phoenix.WebComponent.TopAppBar
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
  ## If the URL is absolute, only certain schemas are allowed to avoid JavaScript injection.
    For example, the following will fail
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

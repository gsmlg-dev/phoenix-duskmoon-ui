defmodule Phoenix.WebComponent.Helpers.Link do
  @moduledoc """
  Conveniences for working with links and URLs in HTML.
  """

  import Phoenix.HTML.Tag
  alias Phoenix.LiveView.Socket

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

  @doc """
  Generates a link to the given URL.

  ## Examples

      wc_link("hello", to: "/world")
      #=> <a href="/world"><wc-button>hello</wc-button></a>

      wc_link("hello", to: URI.parse("https://elixir-lang.org"))
      #=> <a href="https://elixir-lang.org"><wc-button>hello</wc-button></a>

      wc_link("<hello>", to: "/world")
      #=> <a href="/world"><wc-button>&lt;hello&gt;</wc-button></a>

      wc_link("<hello>", to: "/world", class: "btn")
      #=> <a class="btn" href="/world"><wc-button>&lt;hello&gt;</wc-button></a>

      wc_link("delete", to: "/the_world", data: [confirm: "Really?"])
      #=> <a data-confirm="Really?" href="/the_world"><wc-button>delete</wc-button></a>

      # If you supply a method other than `:get`:
      wc_link("delete", to: "/everything", method: :delete)
      #=> <a href="/everything" data-csrf="csrf_token" data-method="delete" data-to="/everything"><wc-button>delete</wc-button></a>

      # You can use a `do ... end` block too:
      link to: "/hello" do
        "world"
      end
      #=> <a href="/hello"><wc-button>world</wc-button><a>

  ## Options

    * `:to` - the page to link to. This option is required

    * `:method` - the method to use with the link. In case the
      method is not `:get`, the link is generated inside the form
      which sets the proper information. In order to submit the
      form, JavaScript must be enabled

    * `:csrf_token` - a custom token to use for links with a method
      other than `:get`.

  All other options are forwarded to the underlying `<a>` tag.

  ## Data attributes

  Data attributes are added as a keyword list passed to the `data` key.
  The following data attributes are supported:

    * `data-confirm` - shows a confirmation prompt before
      generating and submitting the form when `:method`
      is not `:get`.

  ## CSRF Protection

  By default, CSRF tokens are generated through `Plug.CSRFProtection`.
  """
  def wc_link(text, opts)

  def wc_link(opts, do: contents) when is_list(opts) do
    wc_link(contents, opts)
  end

  def wc_link(_text, opts) when not is_list(opts) do
    raise ArgumentError, "wc_link/2 requires a keyword list as second argument"
  end

  def wc_link(text, opts) do
    {to, opts} = pop_required_option!(opts, :to, "expected non-nil value for :to in wc_link/2")
    {method, opts} = Keyword.pop(opts, :method, :get)

    if method == :get do
      # Call link attributes to validate `to`
      [data: data] = link_attributes(to, [])
      {linkOpts, opts} = pop_link_attr(Keyword.delete(opts, :csrf_token))

      content_tag(:"wc-button", text, [href: data[:to]] ++ linkOpts ++ opts)
    else
      {csrf_token, opts} = Keyword.pop(opts, :csrf_token, true)
      opts = Keyword.put_new(opts, :rel, "nofollow")

      [data: data] =
        link_attributes(to, method: method, csrf_token: csrf_token)

      {linkOpts, opts} = pop_link_attr(opts)

      content_tag(:"wc-button", text, [data: data, href: data[:to]] ++ linkOpts ++ opts)
    end
  end

  @doc """
  Generates a button tag that uses the Javascript function handleClick()
  (see phoenix_html.js) to submit the form data.

  Useful to ensure that links that change data are not triggered by
  search engines and other spidering software.

  ## Examples

      button("hello", to: "/world")
      #=> <button class="button" data-csrf="csrf_token" data-method="post" data-to="/world">hello</button>

      button("hello", to: "/world", method: :get, class: "btn")
      #=> <button class="btn" data-method="get" data-to="/world">hello</button>

  ## Options

    * `:to` - the page to link to. This option is required

    * `:method` - the method to use with the button. Defaults to :post.

  All other options are forwarded to the underlying button input.

  When the `:method` is set to `:get` and the `:to` URL contains query
  parameters the generated form element will strip the parameters in accordance
  with the [W3C](https://www.w3.org/TR/html401/interact/forms.html#h-17.13.3.4)
  form specification.

  ## Data attributes

  Data attributes are added as a keyword list passed to the
  `data` key. The following data attributes are supported:

    * `data-confirm` - shows a confirmation prompt before generating and
      submitting the form.
  """
  def wc_button(opts, do: contents) do
    wc_button(contents, opts)
  end

  def wc_button(text, opts) do
    {to, opts} = pop_required_option!(opts, :to, "option :to is required in wc_button/2")

    {link_opts, opts} =
      opts
      |> Keyword.put_new(:method, :post)
      |> Keyword.split([:method, :csrf_token])

    link_attributes = link_attributes(to, link_opts)
    content_tag(:"wc-button", text, link_attributes ++ opts)
  end

  defp pop_required_option!(opts, key, error_message) do
    {value, opts} = Keyword.pop(opts, key)

    unless value do
      raise ArgumentError, error_message
    end

    {value, opts}
  end

  defp pop_link_attr(opts) do
    list = [
      :data,
      :download,
      :href,
      :hreflang,
      :media,
      :ping,
      :referrerpolicy,
      :rel,
      :target,
      :type
    ]

    Enum.reduce(list, {[], opts}, fn name, {pop, list} ->
      case Keyword.pop(list, name) do
        {val, list} when is_nil(val) ->
          {pop, list}

        {val, list} ->
          {Keyword.put(pop, name, val), list}
      end
    end)
  end

  @doc false
  def wc_live_patch(opts) when is_list(opts) do
    wc_live_link("patch", Keyword.fetch!(opts, :do), Keyword.delete(opts, :do))
  end

  @doc """
  Generates a link that will patch the current LiveView.
  When navigating to the current LiveView,
  `c:Phoenix.LiveView.handle_params/3` is
  immediately invoked to handle the change of params and URL state.
  Then the new state is pushed to the client, without reloading the
  whole page while also maintaining the current scroll position.
  For live redirects to another LiveView, use `wc_live_redirect/2`.
  ## Options
    * `:to` - the required path to link to.
    * `:replace` - the flag to replace the current history or push a new state.
      Defaults `false`.
  All other options are forwarded to the anchor tag.
  ## Examples
      <%= wc_live_patch "home", to: Routes.page_path(@socket, :index) %>
      <%= wc_live_patch "next", to: Routes.live_path(@socket, MyLive, @page + 1) %>
      <%= wc_live_patch to: Routes.live_path(@socket, MyLive, dir: :asc), replace: false do %>
        Sort By Price
      <% end %>
  """
  def wc_live_patch(text, opts)

  def wc_live_patch(%Socket{}, _) do
    raise """
    you are invoking wc_live_patch/2 with a socket but a socket is not expected.
    If you want to wc_live_patch/2 inside a LiveView, use push_patch/2 instead.
    If you are inside a template, make the sure the first argument is a string.
    """
  end

  def wc_live_patch(opts, do: block) when is_list(opts) do
    wc_live_link("patch", block, opts)
  end

  def wc_live_patch(text, opts) when is_list(opts) do
    wc_live_link("patch", text, opts)
  end

  @doc false
  def wc_live_redirect(opts) when is_list(opts) do
    wc_live_link("redirect", Keyword.fetch!(opts, :do), Keyword.delete(opts, :do))
  end

  @doc """
  Generates a link that will redirect to a new LiveView of the same live session.
  The current LiveView will be shut down and a new one will be mounted
  in its place, without reloading the whole page. This can
  also be used to remount the same LiveView, in case you want to start
  fresh. If you want to navigate to the same LiveView without remounting
  it, use `wc_live_patch/2` instead.
  *Note*: The live redirects are only supported between two LiveViews defined
  under the same live session. See `Phoenix.LiveView.Router.live_session/3` for
  more details.
  ## Options
    * `:to` - the required path to link to.
    * `:replace` - the flag to replace the current history or push a new state.
      Defaults `false`.
  All other options are forwarded to the anchor tag.
  ## Examples
      <%= wc_live_redirect "home", to: Routes.page_path(@socket, :index) %>
      <%= wc_live_redirect "next", to: Routes.live_path(@socket, MyLive, @page + 1) %>
      <%= wc_live_redirect to: Routes.live_path(@socket, MyLive, dir: :asc), replace: false do %>
        Sort By Price
      <% end %>
  """
  def wc_live_redirect(text, opts)

  def wc_live_redirect(%Socket{}, _) do
    raise """
    you are invoking wc_live_redirect/2 with a socket but a socket is not expected.
    If you want to wc_live_redirect/2 inside a LiveView, use push_redirect/2 instead.
    If you are inside a template, make the sure the first argument is a string.
    """
  end

  def wc_live_redirect(opts, do: block) when is_list(opts) do
    wc_live_link("redirect", block, opts)
  end

  def wc_live_redirect(text, opts) when is_list(opts) do
    wc_live_link("redirect", text, opts)
  end

  defp wc_live_link(type, block_or_text, opts) do
    {uri, opts} = pop_required_option!(opts, :to, "option :to is required in wc_live_link/2")
    replace = Keyword.get(opts, :replace, false)
    kind = if replace, do: "replace", else: "push"

    data = [phx_link: type, phx_link_state: kind]

    opts =
      opts
      |> Keyword.update(:data, data, &Keyword.merge(&1, data))
      |> Keyword.put(:href, uri)

    {linkOpts, opts} = pop_link_attr(opts)

    content_tag(:"wc-button", linkOpts ++ opts, do: block_or_text)
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

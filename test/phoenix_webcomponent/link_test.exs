defmodule Phoenix.WebComponent.LinkTest do
  use ExUnit.Case, async: true

  import Phoenix.HTML
  import Phoenix.WebComponent.Link

  test "wc_link with post" do
    csrf_token = Plug.CSRFProtection.get_csrf_token()

    assert safe_to_string(wc_link("hello", to: "/world", method: :post)) ==
             ~s[<a data-csrf="#{csrf_token}" data-method="post" data-to="/world" href="/world" rel="nofollow"><mwc-button>hello</mwc-button></a>]
  end

  test "wc_link with %URI{}" do
    url = "https://elixir-lang.org/"

    assert safe_to_string(wc_link("elixir", to: url)) ==
             safe_to_string(wc_link("elixir", to: URI.parse(url)))

    path = "/elixir"

    assert safe_to_string(wc_link("elixir", to: path)) ==
             safe_to_string(wc_link("elixir", to: URI.parse(path)))
  end

  test "wc_link with put/delete" do
    csrf_token = Plug.CSRFProtection.get_csrf_token()

    assert safe_to_string(wc_link("hello", to: "/world", method: :put)) ==
             ~s[<a data-csrf="#{csrf_token}" data-method="put" data-to="/world" href="/world" rel="nofollow"><mwc-button>hello</mwc-button></a>]
  end

  test "wc_link with put/delete without csrf_token" do
    assert safe_to_string(wc_link("hello", to: "/world", method: :put, csrf_token: false)) ==
             ~s[<a data-method="put" data-to="/world" href="/world" rel="nofollow"><mwc-button>hello</mwc-button></a>]
  end

  test "wc_link with :do contents" do
    assert ~s[<a href="/hello"><mwc-button><p>world</p></mwc-button></a>] ==
             safe_to_string(
               wc_link to: "/hello" do
                 Phoenix.HTML.Tag.content_tag(:p, "world")
               end
             )

    assert safe_to_string(
             wc_link(to: "/hello") do
               "world"
             end
           ) == ~s[<a href="/hello"><mwc-button>world</mwc-button></a>]
  end

  test "wc_link with scheme" do
    assert safe_to_string(wc_link("foo", to: "/javascript:alert(<1>)")) ==
             ~s[<a href="/javascript:alert(&lt;1&gt;)"><mwc-button>foo</mwc-button></a>]

    assert safe_to_string(wc_link("foo", to: {:safe, "/javascript:alert(<1>)"})) ==
             ~s[<a href="/javascript:alert(<1>)"><mwc-button>foo</mwc-button></a>]

    assert safe_to_string(wc_link("foo", to: {:javascript, "alert(<1>)"})) ==
             ~s[<a href="javascript:alert(&lt;1&gt;)"><mwc-button>foo</mwc-button></a>]

    assert safe_to_string(wc_link("foo", to: {:javascript, 'alert(<1>)'})) ==
             ~s[<a href="javascript:alert(&lt;1&gt;)"><mwc-button>foo</mwc-button></a>]

    assert safe_to_string(wc_link("foo", to: {:javascript, {:safe, "alert(<1>)"}})) ==
             ~s[<a href="javascript:alert(<1>)"><mwc-button>foo</mwc-button></a>]

    assert safe_to_string(wc_link("foo", to: {:javascript, {:safe, 'alert(<1>)'}})) ==
             ~s[<a href="javascript:alert(<1>)"><mwc-button>foo</mwc-button></a>]
  end

  test "wc_link with invalid args" do
    msg = "expected non-nil value for :to in wc_link/2"

    assert_raise ArgumentError, msg, fn ->
      wc_link("foo", bar: "baz")
    end

    msg = "wc_link/2 requires a keyword list as second argument"

    assert_raise ArgumentError, msg, fn ->
      wc_link("foo", "/login")
    end

    assert_raise ArgumentError, ~r"unsupported scheme given as link", fn ->
      wc_link("foo", to: "javascript:alert(1)")
    end

    assert_raise ArgumentError, ~r"unsupported scheme given as link", fn ->
      wc_link("foo", to: {:safe, "javascript:alert(1)"})
    end

    assert_raise ArgumentError, ~r"unsupported scheme given as link", fn ->
      wc_link("foo", to: {:safe, 'javascript:alert(1)'})
    end
  end

  test "wc_button with post (default)" do
    csrf_token = Plug.CSRFProtection.get_csrf_token()

    assert safe_to_string(wc_button("hello", to: "/world")) ==
             ~s[<mwc-button data-csrf="#{csrf_token}" data-method="post" data-to="/world">hello</mwc-button>]
  end

  test "wc_button with %URI{}" do
    url = "https://elixir-lang.org/"

    assert safe_to_string(wc_button("elixir", to: url, csrf_token: false)) ==
             safe_to_string(wc_button("elixir", to: URI.parse(url), csrf_token: false))
  end

  test "wc_button with post without csrf_token" do
    assert safe_to_string(wc_button("hello", to: "/world", csrf_token: false)) ==
             ~s[<mwc-button data-method="post" data-to="/world">hello</mwc-button>]
  end

  test "wc_button with get does not generate CSRF" do
    assert safe_to_string(wc_button("hello", to: "/world", method: :get)) ==
             ~s[<mwc-button data-method="get" data-to="/world">hello</mwc-button>]
  end

  test "wc_button with do" do
    csrf_token = Plug.CSRFProtection.get_csrf_token()

    output =
      safe_to_string(
        wc_button to: "/world", class: "small" do
          raw("<span>Hi</span>")
        end
      )

    assert output ==
             ~s[<mwc-button class="small" data-csrf="#{csrf_token}" data-method="post" data-to="/world"><span>Hi</span></mwc-button>]
  end

  test "wc_button with class overrides default" do
    csrf_token = Plug.CSRFProtection.get_csrf_token()

    assert safe_to_string(wc_button("hello", to: "/world", class: "btn rounded", id: "btn")) ==
             ~s[<mwc-button class="btn rounded" data-csrf="#{csrf_token}" data-method="post" data-to="/world" id="btn">hello</mwc-button>]
  end

  test "wc_button with invalid args" do
    assert_raise ArgumentError, ~r/unsupported scheme given as link/, fn ->
      wc_button("foo", to: "javascript:alert(1)", method: :get)
    end
  end
end

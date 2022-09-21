defmodule PhxWCStorybookWeb.PageController do
  use PhxWCStorybookWeb, :controller

  def index(conn, %{"p" => page} = _params) do
    render(conn, "index.html", page: String.to_integer(page))
  end

  def index(conn, _params) do
    render(conn, "index.html", page: 1)
  end
end

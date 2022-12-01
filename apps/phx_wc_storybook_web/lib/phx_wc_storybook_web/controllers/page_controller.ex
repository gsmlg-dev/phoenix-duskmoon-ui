defmodule PhxWCStorybookWeb.PageController do
  use PhxWCStorybookWeb, :controller

  def index(conn, %{"mode" => mode} = _params) do
    render(conn, "index.html", mode: mode)
  end

  def index(conn, _params) do
    render(conn, "index.html", mode: "app")
  end
end

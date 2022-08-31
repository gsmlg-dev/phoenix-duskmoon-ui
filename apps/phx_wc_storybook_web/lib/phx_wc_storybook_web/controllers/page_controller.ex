defmodule PhxWCStorybookWeb.PageController do
  use PhxWCStorybookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

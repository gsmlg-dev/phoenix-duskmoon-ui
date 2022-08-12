defmodule PhxWCStoryBookWeb.PageController do
  use PhxWCStoryBookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

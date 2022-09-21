defmodule PhxWCStorybookWeb.PageControllerTest do
  use PhxWCStorybookWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Phoenix WebComponent"
  end
end

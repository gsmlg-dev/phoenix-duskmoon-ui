defmodule DuskmoonStorybookWeb.FunController do
  use DuskmoonStorybookWeb, :controller

  def page(conn, _params) do
    render(conn, :page, layout: false, active_menu: "page")
  end

end

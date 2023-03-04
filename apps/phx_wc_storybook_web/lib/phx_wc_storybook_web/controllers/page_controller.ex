defmodule PhxWCStorybookWeb.PageController do
  use PhxWCStorybookWeb, :controller

  def index(conn, %{"mode" => mode} = _params) do
    render(conn, "index.html", mode: mode, active_menu: "phx-wc-hook")
  end

  def index(conn, _params) do
    render(conn, "index.html", mode: "app", active_menu: "phx-wc-hook")
  end

  def mdi(conn, %{"filter" => filter}) do
    icons =
      Phoenix.WebComponent.Icons.mdi_icons()
      |> Enum.filter(fn n ->
        reg = Regex.compile!("#{filter}", [:caseless])
        Regex.match?(reg, n)
      end)

    render(conn, "mdi.html", mdi_icons: icons, active_menu: "mdi", filter: filter)
  end

  def mdi(conn, _params) do
    icons = Phoenix.WebComponent.Icons.mdi_icons()
    render(conn, "mdi.html", mdi_icons: icons, active_menu: "mdi", filter: "")
  end

  def bsi(conn, %{"filter" => filter}) do
    icons =
      Phoenix.WebComponent.Icons.bsi_icons()
      |> Enum.filter(fn n ->
        reg = Regex.compile!("#{filter}", [:caseless])
        Regex.match?(reg, n)
      end)

    render(conn, "bsi.html", bsi_icons: icons, active_menu: "bsi", filter: filter)
  end

  def bsi(conn, _params) do
    icons = Phoenix.WebComponent.Icons.bsi_icons()
    render(conn, "bsi.html", bsi_icons: icons, active_menu: "bsi", filter: "")
  end
end

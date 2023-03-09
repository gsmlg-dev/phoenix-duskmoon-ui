defmodule PhxWCStorybookWeb.Router do
  use PhxWCStorybookWeb, :router
  import PhoenixStorybook.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhxWCStorybookWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", PhxWCStorybookWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/mdi", PageController, :mdi
    get "/bsi", PageController, :bsi

    get "/page_header", PageController, :page_header
    get "/page_header_demo", PageController, :page_header_demo

    live_storybook("/storybook", backend_module: PhxWCStorybookWeb.Storybook)
  end
end

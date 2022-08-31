defmodule PhxWCStorybookWeb.Router do
  use PhxWCStorybookWeb, :router
  import PhxLiveStorybook.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhxWCStorybookWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhxWCStorybookWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  live_storybook "/storybook",
    otp_app: :phx_wc_storybook_web,
    backend_module: PhxWCStorybookWeb.Storybook

end

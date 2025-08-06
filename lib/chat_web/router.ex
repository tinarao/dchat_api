defmodule ChatWeb.Router do
  alias ChatWeb.Plugs
  use ChatWeb, :router

  pipeline :api do
    plug CORSPlug,
      origin: ["http://localhost:1420"],
      credentials: true

    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Plugs.Protected
  end

  scope "/api", ChatWeb do
    pipe_through :api

    options "/*path", OptionsController, :options

    get "/auth/verify", ApiAuthController, :verify_session
    post "/auth/login", ApiAuthController, :login

    pipe_through :protected
    get "/rooms", ApiRoomsController, :list
    get "/rooms/:id", ApiRoomsController, :show
  end

  if Application.compile_env(:chat, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ChatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

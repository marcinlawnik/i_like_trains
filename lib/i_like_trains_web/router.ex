defmodule ILikeTrainsWeb.Router do
  use ILikeTrainsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ILikeTrainsWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/", PageController, :join
    get "/game", GameController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ILikeTrainsWeb do
  #   pipe_through :api
  # end
end

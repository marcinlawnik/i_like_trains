defmodule ILikeTrainsWeb.PageController do
  alias ILikeTrains.Session

  use ILikeTrainsWeb, :controller

  def index(conn, _params) do
    case Session.get(conn) do
      {:error, _} -> render(conn, "index.html")
      {:ok, _} -> redirect(conn, to: Routes.game_path(conn, :index))
    end
  end

  def join(conn, %{"name" => name}) do
    conn
    |> Session.put(name)
    |> redirect(to: Routes.game_path(conn, :index))
  end

  def leave(conn, _) do
    conn
    |> Session.clear()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

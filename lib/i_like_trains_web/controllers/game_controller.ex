defmodule ILikeTrainsWeb.GameController do
  alias ILikeTrains.Session

  use ILikeTrainsWeb, :controller

  def index(conn, _params) do
    case Session.get(conn) do
      {:error, _} -> redirect(conn, to: Routes.page_path(conn, :index))
      {:ok, session} -> render(conn, "index.html", %{session: session})
    end
  end
end

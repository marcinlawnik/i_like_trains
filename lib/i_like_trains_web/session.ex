defmodule ILikeTrains.Session do
  alias ILikeTrains.PlayerStore

  use ILikeTrainsWeb, :controller

  def put(conn, name) do
    PlayerStore.get_or_create(name)

    conn
    |> put_session(:name, name)
  end

  def get(conn) do
    case get_session(conn, :name) do
      nil -> {:error, :not_found}
      name -> {:ok, %{"name" => name}}
    end
  end

  def clear(conn) do
    conn
    |> clear_session()
  end
end

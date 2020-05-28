defmodule ILikeTrains.Lobby do
  alias ILikeTrains.{Lobby, Player}

  defstruct players: %{}, ready: MapSet.new([])

  def new() do
    %Lobby{}
  end

  def join(%Lobby{players: players} = lobby, %Player{} = player) do
    %Lobby{lobby | players: Map.put(players, player.name, player)}
  end

  def ready(%Lobby{ready: ready} = lobby, %Player{name: name}) do
    %Lobby{lobby | ready: MapSet.put(ready, name)}
  end

  def all_ready?(%Lobby{ready: ready, players: players}) do
    Enum.count(players) === MapSet.size(ready)
  end
end

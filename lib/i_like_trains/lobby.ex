defmodule ILikeTrains.Lobby do
  alias __MODULE__
  alias ILikeTrains.{Game, Player}

  defstruct players: %{}, ready: MapSet.new([])

  def new() do
    %Lobby{}
  end

  def join(%Lobby{players: players} = lobby, %Player{} = player) do
    %Lobby{lobby | players: Map.put(players, player.name, player)}
  end

  def ready(%Lobby{ready: ready, players: players} = lobby, %Player{name: name}) do
    new_lobby = %Lobby{lobby | ready: MapSet.put(ready, name)}

    if all_ready?(new_lobby) do
      Game.new(players)
    else
      new_lobby
    end
  end

  def all_ready?(%Lobby{ready: ready, players: players}) do
    Enum.count(players) === MapSet.size(ready)
  end
end

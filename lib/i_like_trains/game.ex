defmodule ILikeTrains.Game do
  alias ILikeTrains.Game

  defstruct players: %{}, turn: nil, count: 0

  def new(players) do
    [turn | _] = Map.keys(players)
    %Game{players: players, turn: turn}
  end

  # TODO: remove dummy game logic
  def inc(%Game{players: players, turn: turn, count: count} = game) do
    %Game{game | count: count + 1, turn: next_turn(players, turn)}
  end

  defp next_turn(players, current_turn) do
    index = Enum.find_index(players, fn {k, _v} -> k === current_turn end)
    new_index = rem(index + 1, Enum.count(players))

    Map.keys(players)
    |> Enum.at(new_index)
  end
end

defmodule ILikeTrains.Player do
  alias __MODULE__
  alias ILikeTrains.{Graph, MapConfig}

  @initial_train_num 10
  @player_colors ["red", "blue", "yellow", "green", "black"]

  defstruct name: "",
            color: "",
            cards: [],
            trains: @initial_train_num,
            tickets: [],
            tickets_to_choose: [],
            connections: Graph.graph_of_vertices(MapConfig.places_data()),
            points: 0

  def new(name) do
    %Player{name: name}
  end

  def assign_colors(players) do
    {new_players, _} =
      Enum.reduce(players, {%{}, @player_colors}, fn {name, player}, {players_acc, colors} ->
        [color | remaining_colors] = colors
        new_players = Map.put(players_acc, name, %Player{player | color: color})
        {new_players, remaining_colors}
      end)

    new_players
  end
end

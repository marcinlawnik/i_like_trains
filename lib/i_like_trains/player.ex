defmodule ILikeTrains.Player do
  alias ILikeTrains.{Player, Graph, MapConfig}

  @initial_train_num 5

  defstruct name: "",
            cards: [],
            trains: @initial_train_num,
            tickets: [],
            tickets_to_choose: [],
            connections: Graph.graph_of_vertices(MapConfig.places_data()),
            points: 0

  def new(name) do
    %Player{name: name}
  end
end

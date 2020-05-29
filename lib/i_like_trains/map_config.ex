defmodule ILikeTrains.MapConfig do
  @places_data %{
    "a" => %{name: "a", x: 100, y: 100},
    "b" => %{name: "b", x: 300, y: 100},
    "c" => %{name: "c", x: 300, y: 300},
    "d" => %{name: "d", x: 100, y: 300}
  }

  @routes_data [
    # let's keep places in alphabetical order - it will be easier to pattern match them
    %{id: 1, places: ["a", "b"], color: "red", cost: 1, position_shift: "top"},
    %{id: 2, places: ["a", "b"], color: "blue", cost: 1, position_shift: "bottom"},
    %{id: 3, places: ["b", "c"], color: "orange", cost: 3},
    %{id: 4, places: ["c", "d"], color: "pink", cost: 1},
    %{id: 5, places: ["a", "d"], color: "white", cost: 4},
    %{id: 6, places: ["a", "c"], color: "black", cost: 5},
    %{id: 7, places: ["b", "d"], color: "green", cost: 2}
  ]

  @ticket_data [
    %{id: 1, places: ["a", "b"], points: 1},
    %{id: 2, places: ["a", "b"], points: 1},
    %{id: 3, places: ["b", "c"], points: 3},
    %{id: 4, places: ["c", "d"], points: 1},
    %{id: 5, places: ["a", "d"], points: 4},
    %{id: 6, places: ["a", "c"], points: 5},
    %{id: 7, places: ["b", "d"], points: 2},
    %{id: 8, places: ["b", "d"], points: 3}
  ]

  def places_data(), do: @places_data
  def routes_data(), do: @routes_data
  def ticket_data(), do: @ticket_data
end

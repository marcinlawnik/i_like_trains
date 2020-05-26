defmodule ILikeTrains.MapConfig do
  @places_data [
    "a",
    "b",
    "c",
    "d"
  ]

  @routes_data [
    # let's keep places in alphabetical order - it will be easier to pattern match them
    %{id: 1, places: ["a", "b"], color: "red", cost: 1},
    %{id: 2, places: ["a", "b"], color: "blue", cost: 1},
    %{id: 3, places: ["b", "c"], color: "blue", cost: 3},
    %{id: 4, places: ["c", "d"], color: "orange", cost: 1},
    %{id: 5, places: ["a", "d"], color: "white", cost: 4},
    %{id: 6, places: ["a", "c"], color: "black", cost: 5},
    %{id: 7, places: ["b", "d"], color: "pink", cost: 2}
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

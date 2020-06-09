defmodule ILikeTrains.MapConfig do
  @places_data %{
    "place A" => %{name: "place A", x: 100, y: 100},
    "place B" => %{name: "place B", x: 300, y: 100},
    "place C" => %{name: "place C", x: 500, y: 100},
    "place D" => %{name: "place D", x: 500, y: 300},
    "place E" => %{name: "place E", x: 300, y: 300},
    "place F" => %{name: "place F", x: 100, y: 300}
  }

  @routes_data [
    # let's keep places in alphabetical order - it will be easier to pattern match them
    %{id: 1, places: ["place A", "place B"], color: "pink", cost: 1, position_shift: "top"},
    %{id: 2, places: ["place A", "place B"], color: "white", cost: 1, position_shift: "bottom"},
    %{id: 3, places: ["place B", "place C"], color: "blue", cost: 3},
    %{id: 4, places: ["place C", "place D"], color: "yellow", cost: 1, position_shift: "left"},
    %{id: 5, places: ["place C", "place D"], color: "orange", cost: 1, position_shift: "right"},
    %{id: 6, places: ["place D", "place E"], color: "black", cost: 3, position_shift: "top"},
    %{id: 7, places: ["place D", "place E"], color: "red", cost: 3, position_shift: "bottom"},
    %{id: 8, places: ["place E", "place F"], color: "green", cost: 2},
    %{id: 9, places: ["place E", "place F"], color: "pink", cost: 2},
    %{id: 10, places: ["place A", "place F"], color: "white", cost: 3},
    %{id: 11, places: ["place A", "place E"], color: "blue", cost: 4},
    %{id: 12, places: ["place B", "place F"], color: "yellow", cost: 5},
    %{id: 13, places: ["place B", "place D"], color: "orange", cost: 5},
    %{id: 14, places: ["place C", "place E"], color: "black", cost: 4},
    %{id: 15, places: ["place B", "place E"], color: "red", cost: 2, position_shift: "left"},
    %{id: 16, places: ["place B", "place E"], color: "green", cost: 2, position_shift: "right"}
  ]

  @ticket_data [
    %{id: 1, places: ["place A", "place B"], points: 2},
    %{id: 2, places: ["place A", "place C"], points: 6},
    %{id: 3, places: ["place A", "place D"], points: 8},
    %{id: 4, places: ["place B", "place F"], points: 6},
    %{id: 5, places: ["place B", "place D"], points: 6},
    %{id: 6, places: ["place C", "place E"], points: 5},
    %{id: 7, places: ["place C", "place F"], points: 7},
    %{id: 8, places: ["place A", "place F"], points: 3}
  ]

  def places_data(), do: @places_data
  def routes_data(), do: @routes_data
  def ticket_data(), do: @ticket_data |> Enum.shuffle()
end

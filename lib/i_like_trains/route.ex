defmodule ILikeTrains.Route do
  alias ILikeTrains.Route
  # claimable: true & claimed_by: username => taken by user with username
  # claimable: true & claimed_by: nil => alternative route taken, this one can't be claimed
  # claimable: false => can be claimed
  defstruct id: 0, places: [], color: "", cost: 0, claimable: true, claimed_by: nil

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

  def get_initial() do
    @routes_data |> Enum.map(fn data -> struct(Route, data) end)
  end

  def claim_route_by_player(routes, %Route{id: claimed_route_id, places: [from, to]}, player_name) do
    Enum.map(routes, fn %Route{id: route_id, places: [route_from, route_to]} = route ->
      case {route_id, {route_from, route_to}} do
        {^claimed_route_id, _} -> %Route{route | claimable: false, claimed_by: player_name}
        {_, {^from, ^to}} -> %Route{route | claimable: false}
        _ -> route
      end
    end)
  end
end

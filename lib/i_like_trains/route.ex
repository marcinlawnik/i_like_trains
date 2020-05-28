defmodule ILikeTrains.Route do
  alias __MODULE__
  alias ILikeTrains.MapConfig

  # assignable: true & assigned_to: username => taken by user
  # assignable: true & assigned_to: nil => alternative route taken, this one can't be assigned
  # assignable: false => can be claimed
  defstruct id: 0, places: [], color: "", cost: 0, assignable: true, assigned_to: nil

  @routes_data MapConfig.routes_data()
  @multi_routes_usable_above_player_num 3

  def get_initial() do
    @routes_data |> Enum.map(fn data -> struct(Route, data) end)
  end

  def claim_route_by_player(
        routes,
        %Route{id: claimed_route_id, places: [from, to]},
        player_name,
        players_count
      ) do
    Enum.map(routes, fn %Route{id: route_id, places: [route_from, route_to]} = route ->
      case {route_id, {route_from, route_to},
            players_count > @multi_routes_usable_above_player_numd} do
        {^claimed_route_id, _, _} -> %Route{route | assignable: false, assigned_to: player_name}
        {_, {^from, ^to}, false} -> %Route{route | assignable: false}
        {_, {^from, ^to}, true} -> route
        _ -> route
      end
    end)
  end
end

defmodule ILikeTrains.Route do
  alias ILikeTrains.{Route, MapConfig}
  # claimable: true & claimed_by: username => taken by user with username
  # claimable: true & claimed_by: nil => alternative route taken, this one can't be claimed
  # claimable: false => can be claimed
  defstruct id: 0, places: [], color: "", cost: 0, claimable: true, claimed_by: nil

  @routes_data MapConfig.routes_data()

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

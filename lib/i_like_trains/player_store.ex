defmodule ILikeTrains.PlayerStore do
  alias ILikeTrains.Player

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(name) do
    Agent.get(__MODULE__, fn players -> Map.get(players, name) end)
  end

  def get_or_create(name) do
    case get(name) do
      nil ->
        player = Player.new(name)
        Agent.update(__MODULE__, fn players -> Map.put(players, name, player) end)
        player

      player ->
        player
    end
  end
end

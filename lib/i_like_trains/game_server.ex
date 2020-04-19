defmodule ILikeTrains.GameServer do
  alias ILikeTrains.{Lobby, Game, Player, GameServer}

  use GenServer

  ## Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def join(player) do
    GenServer.call(GameServer, {:join, player})
  end

  def ready(player) do
    GenServer.call(GameServer, {:ready, player})
  end

  # TODO: remove dummy game logic
  def inc() do
    GenServer.call(GameServer, :inc)
  end

  ## GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, %Lobby{}}
  end

  @impl true
  def handle_call({:join, %Player{} = player}, _from, %Lobby{} = state) do
    new_lobby = Lobby.join(state, player)
    {:reply, new_lobby, new_lobby}
  end

  @impl true
  def handle_call({:join, %Player{} = _player}, _from, %Game{} = state) do
    # TODO: check if player in game
    {:reply, state, state}
  end

  @impl true
  def handle_call({:ready, %Player{} = player}, _from, %Lobby{} = state) do
    new_lobby = Lobby.ready(state, player)

    if Lobby.all_ready?(new_lobby) do
      new_game = Game.new(new_lobby.players)
      {:reply, new_game, new_game}
    else
      {:reply, new_lobby, new_lobby}
    end
  end

  # TODO: remove dummy game logic
  @impl true
  def handle_call(:inc, _from, %Game{} = state) do
    new_game = Game.inc(state)
    {:reply, new_game, new_game}
  end
end

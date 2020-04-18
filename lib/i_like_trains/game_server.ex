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

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  # def lookup(server, name) do
  #   GenServer.call(server, {:lookup, name})
  # end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  # def create(server, name) do
  #   GenServer.cast(server, {:create, name})
  # end

  ## GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, %Lobby{}}
  end

  # TODO: fallback for Game struct - game in progress
  @impl true
  def handle_call({:join, %Player{} = player}, _from, %Lobby{} = state) do
    new_state = Lobby.join(state, player)
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call({:ready, %Player{} = player}, _from, %Lobby{} = state) do
    new_state = Lobby.ready(state, player)

    if Lobby.all_ready?(new_state) do
      new_game = %Game{players: new_state.players}
      {:reply, new_game, new_game}
    else
      {:reply, new_state, new_state}
    end
  end

  # @impl true
  # def handle_call({:atom, _}, _from, state) do
  #   {:reply, reply_value, state}
  # end

  # @impl true
  # def handle_cast({:atom, _}, state) do
  #   {:noreply, state}
  # end
end

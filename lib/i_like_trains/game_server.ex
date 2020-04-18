defmodule ILikeTrains.GameServer do
  use GenServer

  ## Client API

  @doc """
  Starts the game.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
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
    {:ok, %{}}
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

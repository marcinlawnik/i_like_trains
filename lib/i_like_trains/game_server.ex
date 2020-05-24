defmodule ILikeTrains.GameServer do
  alias ILikeTrains.{Lobby, Game, Player, GameServer}

  use GenServer

  ## Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def join(player_name) do
    GenServer.call(GameServer, {:join, player_name})
  end

  def ready(player_name) do
    GenServer.call(GameServer, {:ready, player_name})
  end

  def take_card_board(index) do
    GenServer.call(GameServer, {:take_card_board, index})
  end

  def take_card_deck() do
    GenServer.call(GameServer, :take_card_deck)
  end

  def claim_route(id) do
    GenServer.call(GameServer, {:claim_route, id})
  end

  def take_tickets(player_name, choosen_ticket_ids) do
    GenServer.call(GameServer, {:take_tickets, player_name, choosen_ticket_ids})
  end

  def request_tickets() do
    GenServer.call(GameServer, :request_tickets)
  end

  ## GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, %Lobby{}}
  end

  @impl true
  def handle_call({:join, player_name}, _from, %Lobby{} = state) do
    new_lobby = Lobby.join(state, %Player{name: player_name})
    {:reply, new_lobby, new_lobby}
  end

  @impl true
  def handle_call({:join, _player}, _from, %Game{} = state) do
    # TODO: check if player in game
    {:reply, state, state}
  end

  @impl true
  def handle_call({:ready, player_name}, _from, %Lobby{} = state) do
    new_lobby = Lobby.ready(state, %Player{name: player_name})

    if Lobby.all_ready?(new_lobby) do
      new_game = Game.new(new_lobby.players)

      {:reply, new_game, new_game}
    else
      {:reply, new_lobby, new_lobby}
    end
  end

  @impl true
  def handle_call({:take_card_board, card_index}, _from, %Game{} = state) do
    new_game = Game.take_card_board(state, card_index)
    {:reply, new_game, new_game}
  end

  @impl true
  def handle_call(:take_card_deck, _from, %Game{} = state) do
    new_game = Game.take_card_deck(state)
    {:reply, new_game, new_game}
  end

  @impl true
  def handle_call({:claim_route, route_id}, _from, %Game{} = state) do
    new_game = Game.claim_route(state, route_id)
    {:reply, new_game, new_game}
  end

  @impl true
  def handle_call({:take_tickets, player_name, choosen_ticket_ids}, _from, %Game{} = state) do
    new_game = Game.take_tickets(state, player_name, choosen_ticket_ids)
    {:reply, new_game, new_game}
  end

  @impl true
  def handle_call(:request_tickets, _from, %Game{} = state) do
    new_game = Game.request_tickets(state)
    {:reply, new_game, new_game}
  end
end

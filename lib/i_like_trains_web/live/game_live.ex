defmodule ILikeTrainsWeb.GameLive do
  alias ILikeTrains.{GameServer, PlayerStore, Lobby, Game}

  use ILikeTrainsWeb, :live_view

  @topic "pub_sub_game_topic"
  @state_update "state_update"

  @impl true
  def mount(_params, %{"name" => name}, socket) do
    # TODO: clause when name is not present in session -> redirect to login
    player = PlayerStore.get(name)
    ILikeTrainsWeb.Endpoint.subscribe(@topic)
    state = GameServer.join(player)

    pub_state(state)
    {:ok, assign(socket, %{state: state, player: player})}
  end

  @impl true
  def render(%{state: state} = assigns) do
    case state do
      %Lobby{} -> Phoenix.View.render(ILikeTrainsWeb.GameView, "lobby.html", assigns)
      %Game{} -> Phoenix.View.render(ILikeTrainsWeb.GameView, "game.html", assigns)
    end
  end

  @impl true
  def handle_event("ready", _, %{assigns: %{player: player}} = socket) do
    new_state = GameServer.ready(player)

    pub_state(new_state)
    {:noreply, assign(socket, %{state: new_state})}
  end

  # TODO: remove dummy game logic
  def handle_event("inc", _, socket) do
    new_state = GameServer.inc()

    pub_state(new_state)
    {:noreply, assign(socket, %{state: new_state})}
  end

  @impl true
  def handle_info(%{event: @state_update, payload: state}, socket) do
    {:noreply, assign(socket, %{state: state})}
  end

  defp pub_state(state) do
    ILikeTrainsWeb.Endpoint.broadcast_from(self(), @topic, @state_update, state)
  end
end

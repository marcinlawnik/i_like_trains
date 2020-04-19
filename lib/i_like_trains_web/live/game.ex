defmodule ILikeTrainsWeb.Live.Game do
  alias ILikeTrains.{GameServer, Lobby, Game}

  use Phoenix.LiveView

  @topic "pub_sub_game_topic"
  @state_update "state_update"

  def mount(_params, %{"player" => player}, socket) do
    ILikeTrainsWeb.Endpoint.subscribe(@topic)
    state = GameServer.join(player)

    pub_state(state)
    {:ok, assign(socket, %{state: state, player: player})}
  end

  def render(%{state: state} = assigns) do
    case state do
      %Lobby{} -> ILikeTrainsWeb.GameView.render("lobby.html", assigns)
      %Game{} -> ILikeTrainsWeb.GameView.render("game.html", assigns)
    end
  end

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

  def handle_info(%{event: @state_update, payload: state}, socket) do
    {:noreply, assign(socket, %{state: state})}
  end

  defp pub_state(state) do
    ILikeTrainsWeb.Endpoint.broadcast_from(self(), @topic, @state_update, state)
  end
end

defmodule ILikeTrainsWeb.Live.Game do
  alias ILikeTrains.{GameServer, Lobby, Game}

  use Phoenix.LiveView

  def mount(_params, %{"player" => player}, socket) do
    # subscribe to game room
    state = GameServer.join(player)

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
    {:noreply, assign(socket, %{state: new_state})}
  end
end

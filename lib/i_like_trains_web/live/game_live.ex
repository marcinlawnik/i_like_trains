defmodule ILikeTrainsWeb.GameLive do
  alias ILikeTrains.{GameServer, Lobby, Game, Card, MapConfig}

  use ILikeTrainsWeb, :live_view

  @topic "pub_sub_game_topic"
  @state_update "state_update"

  @min_initial_tickets_num MapConfig.min_initial_tickets_num_data()
  @min_turn_tickets_num MapConfig.min_turn_tickets_num_data()

  @impl true
  def mount(_params, %{"name" => name}, socket) do
    case GameServer.join(name) do
      {:ok, state} ->
        ILikeTrainsWeb.Endpoint.subscribe(@topic)
        pub_state(state)

        {:ok,
         socket
         |> assign(%{state: state, name: name, available_cards: %{}, take_tickets_message: nil})}

      {:error, _} ->
        {:ok,
         socket
         |> put_flash(:info, "game already in progress - try again later")
         |> redirect(to: Routes.page_path(ILikeTrainsWeb.Endpoint, :leave))}
    end
  end

  @impl true
  def mount(_params, _, socket) do
    {:ok, redirect(socket, to: Routes.page_path(ILikeTrainsWeb.Endpoint, :index))}
  end

  @impl true
  def render(%{state: state, name: name} = assigns) do
    case state do
      %Lobby{} ->
        Phoenix.View.render(ILikeTrainsWeb.GameView, "lobby.html", assigns)

      %Game{} ->
        available_cards = Card.count_by_color(Map.get(state.players, name).cards)

        Phoenix.View.render(ILikeTrainsWeb.GameView, "game.html", %{
          assigns
          | available_cards: available_cards
        })
    end
  end

  @impl true
  def handle_event("ready", _, %{assigns: %{name: name}} = socket) do
    new_state = GameServer.ready(name)
    pub_state(new_state)
    {:noreply, assign(socket, %{state: new_state})}
  end

  @impl true
  def handle_event("not_ready", _, %{assigns: %{name: name}} = socket) do
    new_state = GameServer.not_ready(name)
    pub_state(new_state)
    {:noreply, assign(socket, %{state: new_state})}
  end

  @impl true
  def handle_event("take_initial_tickets", params, %{assigns: %{name: name}} = socket) do
    take_tickets(params, name, @min_initial_tickets_num, socket)
  end

  @impl true
  def handle_event("take_tickets", params, %{assigns: %{name: name}} = socket) do
    take_tickets(params, name, @min_turn_tickets_num, socket)
  end

  @impl true
  def handle_event("take_card_board", %{"index" => index}, socket) do
    new_state = String.to_integer(index) |> GameServer.take_card_board()
    pub_state(new_state)
    {:noreply, assign(socket, %{state: new_state})}
  end

  @impl true
  def handle_event("take_card_deck", _, socket) do
    new_state = GameServer.take_card_deck()
    pub_state(new_state)
    {:noreply, assign(socket, %{state: new_state})}
  end

  @impl true
  def handle_event("claim_route", %{"id" => id}, socket) do
    new_state = String.to_integer(id) |> GameServer.claim_route()
    pub_state(new_state)
    {:noreply, assign(socket, %{state: new_state})}
  end

  @impl true
  def handle_event("request_tickets", _, socket) do
    new_state = GameServer.request_tickets()
    {:noreply, assign(socket, %{state: new_state})}
  end

  @impl true
  def handle_event("leave_game", _, %{assigns: %{name: name}} = socket) do
    ILikeTrainsWeb.Endpoint.unsubscribe(@topic)
    GameServer.leave_game(name)
    {:noreply, redirect(socket, to: Routes.page_path(ILikeTrainsWeb.Endpoint, :leave))}
  end

  @impl true
  def handle_info(%{event: @state_update, payload: state}, socket) do
    {:noreply, assign(socket, %{state: state})}
  end

  defp pub_state(state) do
    ILikeTrainsWeb.Endpoint.broadcast_from(self(), @topic, @state_update, state)
  end

  defp take_tickets(params, name, min, socket) do
    choosen_ticket_ids =
      Map.keys(params)
      |> Enum.map(fn val -> String.to_integer(val) end)

    if Enum.count(choosen_ticket_ids) < min do
      {:noreply,
       assign(socket, %{
         take_tickets_message: "You need to select at least #{min} tickets"
       })}
    else
      new_state = GameServer.take_tickets(name, choosen_ticket_ids)
      pub_state(new_state)

      {:noreply,
       assign(socket, %{
         state: new_state,
         take_tickets_message: nil
       })}
    end
  end
end

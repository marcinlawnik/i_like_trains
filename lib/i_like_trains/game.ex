defmodule ILikeTrains.Game do
  alias ILikeTrains.{Game, Card, Player, Route, Ticket}

  @initial_cards 4
  @card_board_num 5
  @initial_tickets 4
  @turn_tickets 3

  @state_one_more_card "one_more_card"
  @state_initial_tickets "take_initial_tickets"

  defstruct players: %{},
            cards_deck: [],
            cards_board: [],
            routes: [],
            tickets: [],
            turn: nil,
            state: nil

  def new(players) do
    first_turn = List.first(Map.keys(players))
    routes = Route.get_initial()
    tickets = Ticket.get_initial()

    {cards_board, cards_deck} =
      Card.new_deck()
      |> Card.take_n(@card_board_num)

    %Game{
      players: players,
      cards_deck: cards_deck,
      cards_board: cards_board,
      routes: routes,
      tickets: tickets,
      turn: first_turn,
      state: @state_initial_tickets
    }
    |> distribute_cards()
    |> distribute_initial_tickets()
  end

  defp next_turn(players, current_turn) do
    index =
      Enum.find_index(players, fn {player_name, _player} -> player_name === current_turn end)

    new_index = rem(index + 1, Enum.count(players))
    Enum.at(Map.keys(players), new_index)
  end

  def distribute_cards(%Game{players: players, cards_deck: cards_deck} = game) do
    {players_with_cards, remaining_cards} =
      Enum.reduce(players, {%{}, cards_deck}, fn {_k, player}, {players, cards} ->
        {cards, remaining_cards} = Card.take_n(cards, @initial_cards)
        new_players = Map.put(players, player.name, %Player{player | cards: cards})
        {new_players, remaining_cards}
      end)

    %Game{game | players: players_with_cards, cards_deck: remaining_cards}
  end

  def distribute_initial_tickets(%Game{players: players, tickets: tickets} = game) do
    {players_with_tickets, remaining_tickets} =
      Enum.reduce(players, {%{}, tickets}, fn {_k, player}, {players, tickets} ->
        {tickets, remaining_tickets} = Ticket.take_n(tickets, @initial_tickets)
        new_players = Map.put(players, player.name, %Player{player | tickets_to_choose: tickets})
        {new_players, remaining_tickets}
      end)

    %Game{game | players: players_with_tickets, tickets: remaining_tickets}
  end

  def take_card_board(%Game{} = game, card_index) do
    index = String.to_integer(card_index)
    card = Enum.at(game.cards_board, index)
    [new_card | remaining_deck] = game.cards_deck
    new_cards_board = List.replace_at(game.cards_board, index, new_card)

    current_player = Map.get(game.players, game.turn)
    player_with_card = %Player{current_player | cards: [card | current_player.cards]}

    new_game = %Game{
      game
      | cards_deck: remaining_deck,
        cards_board: new_cards_board,
        players: Map.put(game.players, game.turn, player_with_card)
    }

    case {game.state, Card.is_joker?(card)} do
      {@state_one_more_card, _} ->
        %Game{new_game | turn: next_turn(game.players, game.turn), state: nil}

      {_, true} ->
        %Game{new_game | turn: next_turn(game.players, game.turn), state: nil}

      {_, false} ->
        %Game{new_game | state: @state_one_more_card}
    end
  end

  def take_card_deck(%Game{} = game) do
    [new_card | remaining_deck] = game.cards_deck

    current_player = Map.get(game.players, game.turn)
    player_with_card = %Player{current_player | cards: [new_card | current_player.cards]}

    new_game = %Game{
      game
      | cards_deck: remaining_deck,
        players: Map.put(game.players, game.turn, player_with_card)
    }

    case game.state do
      @state_one_more_card ->
        %Game{new_game | turn: next_turn(game.players, game.turn), state: nil}

      _ ->
        %Game{new_game | state: @state_one_more_card}
    end
  end

  def claim_route(%Game{routes: routes, players: players, turn: turn} = game, route_id) do
    route_id_int = String.to_integer(route_id)
    route = Enum.find(routes, fn %Route{id: id} -> id === route_id_int end)

    current_player = Map.get(players, turn)
    new_cards = Card.remove_n_by_color(current_player.cards, route.color, route.cost)

    new_players =
      Map.put(players, turn, %Player{
        current_player
        | cards: new_cards,
          trains: current_player.trains - route.cost
      })

    routes = Route.claim_route_by_player(routes, route, turn)

    %Game{game | players: new_players, routes: routes, turn: next_turn(players, turn)}
  end

  def take_tickets(
        %Game{players: players, turn: turn, state: game_state} = game,
        player_name,
        choosen_ticket_ids
      ) do
    player = Map.get(players, player_name)

    {choosen_tickets, remaining_tickets} =
      Enum.reduce(player.tickets_to_choose, {[], []}, fn ticket, {to_choose, remaining} ->
        if Enum.member?(choosen_ticket_ids, ticket.id) do
          {to_choose ++ [ticket], remaining}
        else
          {to_choose, remaining ++ [ticket]}
        end
      end)

    all_players_taken_tickets =
      Enum.all?(players, fn {_k, player} ->
        Enum.count(player.tickets_to_choose) === 0 or player.name === player_name
      end)

    {state, turn} =
      case {all_players_taken_tickets, game_state} do
        {true, @state_initial_tickets} -> {nil, turn}
        {_, nil} -> {nil, next_turn(players, turn)}
        _ -> {game_state, turn}
      end

    %Game{
      game
      | players:
          Map.put(players, player_name, %Player{
            player
            | tickets: choosen_tickets ++ player.tickets,
              tickets_to_choose: []
          }),
        tickets: game.tickets ++ remaining_tickets,
        state: state,
        turn: turn
    }
  end

  def request_tickets(%Game{players: players, turn: turn, tickets: tickets} = game) do
    {taken, remaining} = Ticket.take_n(tickets, @turn_tickets)
    current_player = Map.get(players, turn)

    %Game{
      game
      | tickets: remaining,
        players: Map.put(players, turn, %Player{current_player | tickets_to_choose: taken})
    }
  end
end

defmodule ILikeTrains.Game do
  alias __MODULE__
  alias ILikeTrains.{Lobby, Card, Player, Route, Ticket, Graph, MapConfig}

  @cards_on_hand_num 4
  @cards_on_board_num 5
  @initial_tickets_num 4
  @turn_tickets_num 3
  @points_for_trains %{1 => 1, 2 => 2, 3 => 4, 4 => 7, 5 => 10, 6 => 15}

  @state_one_more_card "one_more_card"
  @state_initial_tickets "take_initial_tickets"
  @state_game_finished "game_finished"

  defstruct players: %{},
            cards_deck: [],
            cards_board: [],
            places: MapConfig.places_data(),
            routes: [],
            tickets: [],
            turn: nil,
            state: nil,
            last_turn: nil

  def new(players) do
    first_turn = List.first(Map.keys(players))
    routes = Route.get_initial()
    tickets = Ticket.get_initial()

    {cards_board, cards_deck} =
      Card.new_deck()
      |> Card.take_n(@cards_on_board_num)

    %Game{
      players: Player.assign_colors(players),
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

  defp next_turn(%Game{players: players, turn: turn, last_turn: last_turn} = game) do
    current_player = Map.get(players, turn)

    if last_turn === turn do
      players_with_points = count_points_for_tickets(players)
      %Game{game | players: players_with_points, state: @state_game_finished}
    else
      index =
        Map.keys(players)
        |> Enum.find_index(fn name -> name === turn end)

      new_index = rem(index + 1, Enum.count(players))
      new_turn = Enum.at(Map.keys(players), new_index)

      new_last_turn =
        if current_player.trains <= 2 and last_turn === nil do
          turn
        else
          last_turn
        end

      %Game{game | turn: new_turn, last_turn: new_last_turn}
    end
  end

  def distribute_cards(%Game{players: players, cards_deck: cards_deck} = game) do
    {players_with_cards, remaining_cards} =
      Enum.reduce(players, {%{}, cards_deck}, fn {_k, player}, {players, cards} ->
        {cards, remaining_cards} = Card.take_n(cards, @cards_on_hand_num)
        new_players = Map.put(players, player.name, %Player{player | cards: cards})
        {new_players, remaining_cards}
      end)

    %Game{game | players: players_with_cards, cards_deck: remaining_cards}
  end

  def distribute_initial_tickets(%Game{players: players, tickets: tickets} = game) do
    {players_with_tickets, remaining_tickets} =
      Enum.reduce(players, {%{}, tickets}, fn {_k, player}, {players, tickets} ->
        {tickets, remaining_tickets} = Ticket.take_n(tickets, @initial_tickets_num)
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
        %Game{new_game | state: nil} |> next_turn()

      {_, true} ->
        %Game{new_game | state: nil} |> next_turn()

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
        %Game{new_game | state: nil} |> next_turn()

      _ ->
        %Game{new_game | state: @state_one_more_card}
    end
  end

  def claim_route(%Game{routes: routes, players: players, turn: turn} = game, route_id) do
    route_id_int = String.to_integer(route_id)
    route = Enum.find(routes, fn %Route{id: id} -> id === route_id_int end)
    %Route{places: places} = route

    current_player = Map.get(players, turn)
    updated_cards = Card.remove_n_by_color(current_player.cards, route.color, route.cost)
    updated_connections = Graph.add_route(current_player.connections, places)

    player = %Player{
      current_player
      | cards: updated_cards,
        trains: current_player.trains - route.cost,
        points: current_player.points + Map.get(@points_for_trains, route.cost),
        connections: updated_connections
    }

    players = Map.put(players, turn, player)
    players_count = Enum.count(players)
    routes = Route.claim_route_by_player(routes, route, turn, players_count)

    %Game{game | players: players, routes: routes} |> next_turn()
  end

  def take_tickets(
        %Game{players: players, state: state} = game,
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

    new_game = %Game{
      game
      | players:
          Map.put(players, player_name, %Player{
            player
            | tickets: choosen_tickets ++ player.tickets,
              tickets_to_choose: []
          }),
        tickets: game.tickets ++ remaining_tickets
    }

    case {all_players_taken_tickets, state} do
      # initial state = all players taken tickets
      {true, @state_initial_tickets} -> %Game{new_game | state: nil}
      # initial state = not all players taken tickets
      {false, @state_initial_tickets} -> new_game
      # draw tickets by player during game
      {_, nil} -> %Game{new_game | state: nil} |> next_turn()
      _ -> new_game
    end
  end

  def request_tickets(%Game{players: players, turn: turn, tickets: tickets} = game) do
    {taken, remaining} = Ticket.take_n(tickets, @turn_tickets_num)
    current_player = Map.get(players, turn)

    %Game{
      game
      | tickets: remaining,
        players: Map.put(players, turn, %Player{current_player | tickets_to_choose: taken})
    }
  end

  def count_points_for_tickets(players) do
    Enum.reduce(players, %{}, fn {player_name,
                                  %Player{
                                    tickets: tickets,
                                    connections: connections,
                                    points: points
                                  } = player},
                                 acc ->
      tickets_points =
        Enum.reduce(tickets, 0, fn %Ticket{places: [from, to], points: ticket_points}, acc ->
          if Graph.are_connected?(connections, [from, to]) do
            acc + ticket_points
          else
            acc - ticket_points
          end
        end)

      Map.put(acc, player_name, %Player{player | points: points + tickets_points})
    end)
  end

  def leave_game(%Game{players: players} = game, name) do
    remaining_players = Map.delete(players, name)

    if Enum.count(remaining_players) > 0 do
      %Game{game | players: remaining_players}
    else
      Lobby.new()
    end
  end
end

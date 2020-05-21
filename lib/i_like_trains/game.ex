defmodule ILikeTrains.Game do
  alias ILikeTrains.{Game, Card, Player, Route}

  @initial_cards 4
  @card_board_num 5

  @state_one_more_card "one_more_card"

  defstruct players: %{},
            cards_deck: [],
            cards_board: [],
            routes: [],
            turn: nil,
            state: nil,
            count: 0

  def new([%Player{name: name} | _] = players) do
    cards = Card.new_deck()
    routes = Route.get_initial()
    {cards_board, cards_deck} = Card.take_n(cards, @card_board_num)

    %Game{
      players: players,
      turn: name,
      routes: routes,
      cards_board: cards_board,
      cards_deck: cards_deck
    }
    |> distribute_cards()
  end

  defp next_turn(players, current_turn) do
    index =
      Enum.find_index(players, fn {player_name, _player} -> player_name === current_turn end)

    new_index = rem(index + 1, Enum.count(players))
    Enum.at(Map.keys(players), new_index)
  end

  def distribute_cards(%Game{players: players} = game) do
    {players, game} =
      Enum.reduce(players, {%{}, game}, fn player, {players, game} ->
        {hand, remaining_cards} = Card.take_n(game.cards_deck, @initial_cards)
        new_players = Map.put(players, player.name, %Player{player | cards: hand})
        new_game = %Game{game | cards_deck: remaining_cards}
        {new_players, new_game}
      end)

    %Game{game | players: players}
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
    new_players = Map.put(players, turn, %Player{current_player | cards: new_cards})

    routes = Route.claim_route_by_player(routes, route, turn)

    %Game{game | players: new_players, routes: routes, turn: next_turn(players, turn)}
  end

  # TODO: remove dummy game logic
  def inc(%Game{players: players, turn: turn, count: count} = game) do
    %Game{game | count: count + 1, turn: next_turn(players, turn)}
  end
end

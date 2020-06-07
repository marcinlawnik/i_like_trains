defmodule ILikeTrains.Card do
  alias __MODULE__

  defstruct color: nil

  @colors ["pink", "white", "blue", "yellow", "orange", "black", "red", "green"]
  @joker "joker"
  @color_num 12
  @joker_num 14

  def new_deck() do
    cards =
      @colors
      |> Enum.map(fn color -> List.duplicate(color, @color_num) end)
      |> List.flatten()

    (List.duplicate(@joker, @joker_num) ++ cards)
    |> Enum.map(fn color -> %Card{color: color} end)
    |> Enum.shuffle()
  end

  def take_n(cards, n) do
    taken_cards = Enum.take(cards, n)
    remaining_cards = Enum.slice(cards, n..-1)
    {taken_cards, remaining_cards}
  end

  def is_joker?(%Card{color: @joker}), do: true
  def is_joker?(%Card{}), do: false

  def remove_n_by_color(cards, color, n) do
    {rem_cards, rem_count} = remove_at_most_n_by_color(cards, color, n)

    if rem_count === 0 do
      Enum.reverse(rem_cards)
    else
      {rem_cards_after_jokers, _} = remove_at_most_n_by_color(Enum.reverse(rem_cards), @joker, n)
      Enum.reverse(rem_cards_after_jokers)
    end
  end

  def remove_at_most_n_by_color(cards, color, n) do
    {rem_cards, rem_count} =
      Enum.reduce(cards, {[], n}, fn %Card{color: card_color} = card, {cards, count} ->
        if count === 0 do
          {[card | cards], 0}
        else
          case card_color do
            ^color -> {cards, count - 1}
            _ -> {[card | cards], count}
          end
        end
      end)

    {rem_cards, rem_count}
  end

  def count_by_color(cards) do
    count = Enum.map(@colors, fn color -> {color, 0} end) |> Map.new()

    Enum.reduce(cards, count, fn %Card{color: color}, cards_count ->
      case color do
        @joker ->
          Map.new(Enum.map(cards_count, fn {col, val} -> {col, val + 1} end))

        _ ->
          val = Map.get(cards_count, color)
          Map.put(cards_count, color, val + 1)
      end
    end)
  end
end

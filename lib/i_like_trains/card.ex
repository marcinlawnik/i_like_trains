defmodule ILikeTrains.Card do
  alias __MODULE__
  alias ILikeTrains.MapConfig

  defstruct color: nil

  @colors MapConfig.colors_data()
  @color_num MapConfig.color_num_data()
  @joker_num MapConfig.joker_num_data()
  @joker "joker"

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
      rem_cards
    else
      {rem_cards_after_jokers, _} = remove_at_most_n_by_color(rem_cards, @joker, rem_count)
      rem_cards_after_jokers
    end
  end

  def remove_at_most_n_by_color(cards, _color, 0), do: {cards, 0}
  def remove_at_most_n_by_color([], _color, n), do: {[], n}

  def remove_at_most_n_by_color([%Card{color: card_color} = card | remaining], color, n) do
    case card_color do
      ^color ->
        remove_at_most_n_by_color(remaining, color, n - 1)

      _ ->
        {remaining_cards, remaining_count} = remove_at_most_n_by_color(remaining, color, n)
        {[card | remaining_cards], remaining_count}
    end
  end

  def count_by_color(cards) do
    colors_count = Enum.map(@colors, fn color -> {color, 0} end) |> Map.new()
    count_by_color(colors_count, cards)
  end

  defp count_by_color(colors_count, []), do: colors_count

  defp count_by_color(colors_count, [%Card{color: color} | remaining_cards]) do
    case color do
      @joker ->
        updated_colors_count =
          Enum.map(colors_count, fn {col, val} -> {col, val + 1} end)
          |> Map.new()

        count_by_color(updated_colors_count, remaining_cards)

      _ ->
        val = Map.get(colors_count, color)
        updated_colors_count = Map.put(colors_count, color, val + 1)
        count_by_color(updated_colors_count, remaining_cards)
    end
  end
end

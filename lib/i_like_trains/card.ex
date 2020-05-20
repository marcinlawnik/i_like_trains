defmodule ILikeTrains.Card do
  alias ILikeTrains.Card

  defstruct color: nil

  # 12 each color
  # 14 locomotives
  @colors ["pink", "white", "blue", "yellow", "orange", "black", "red", "green"]
  @joker "joker"

  def new_deck() do
    cards =
      @colors
      |> Enum.map(fn color -> List.duplicate(color, 12) end)
      |> List.flatten()

    (List.duplicate(@joker, 12) ++ cards)
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
end

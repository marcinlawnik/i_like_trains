defmodule ILikeTrains.Player do
  alias ILikeTrains.Player

  defstruct name: "", cards: []

  def new(name) do
    %Player{name: name}
  end
end

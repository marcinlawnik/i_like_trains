defmodule ILikeTrains.Player do
  alias ILikeTrains.Player

  @initial_train_num 35

  defstruct name: "", cards: [], trains: @initial_train_num

  def new(name) do
    %Player{name: name}
  end
end

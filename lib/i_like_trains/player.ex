defmodule ILikeTrains.Player do
  alias ILikeTrains.Player

  defstruct [:name]

  def new(name) do
    %Player{name: name}
  end
end

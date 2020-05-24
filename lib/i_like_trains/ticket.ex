defmodule ILikeTrains.Ticket do
  alias ILikeTrains.Ticket
  # game init - 4, need to take 2 or more
  # later - taking tickets - 3, need to take 1 or more
  defstruct id: 0, places: [], points: 0

  @ticket_data [
    %{id: 1, places: ["a", "b"], points: 1},
    %{id: 2, places: ["a", "b"], points: 1},
    %{id: 3, places: ["b", "c"], points: 3},
    %{id: 4, places: ["c", "d"], points: 1},
    %{id: 5, places: ["a", "d"], points: 4},
    %{id: 6, places: ["a", "c"], points: 5},
    %{id: 7, places: ["b", "d"], points: 2},
    %{id: 8, places: ["b", "d"], points: 3}
  ]

  def get_initial() do
    @ticket_data |> Enum.map(fn data -> struct(Ticket, data) end)
  end

  def take_n(tickets, n) do
    taken_tickets = Enum.take(tickets, n)
    remaining_tickets = Enum.slice(tickets, n..-1)
    {taken_tickets, remaining_tickets}
  end
end

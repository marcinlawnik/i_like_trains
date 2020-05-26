defmodule ILikeTrains.Ticket do
  alias ILikeTrains.{Ticket, MapConfig}

  defstruct id: 0, places: [], points: 0

  @ticket_data MapConfig.ticket_data()

  def get_initial() do
    @ticket_data |> Enum.map(fn data -> struct(Ticket, data) end)
  end

  def take_n(tickets, n) do
    taken_tickets = Enum.take(tickets, n)
    remaining_tickets = Enum.slice(tickets, n..-1)
    {taken_tickets, remaining_tickets}
  end
end

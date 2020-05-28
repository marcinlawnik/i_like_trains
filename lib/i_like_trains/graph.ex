defmodule ILikeTrains.Graph do
  alias __MODULE__

  @type t :: %ILikeTrains.Graph{vertices: %{required(String.t()) => MapSet.t()} | nil}
  defstruct vertices: %{}

  def graph_of_vertices(vertices_list) do
    vertices =
      vertices_list
      |> Enum.map(fn vertex -> {vertex, MapSet.new()} end)
      |> Map.new()

    %Graph{vertices: vertices}
  end

  def are_connected?(%Graph{vertices: vertices}, [from, to]) do
    are_connected?(vertices, to, Map.get(vertices, from), MapSet.new([from]))
  end

  defp are_connected?(vertices, dest, todo, done) do
    case {Enum.member?(done, dest), Enum.count(todo)} do
      {true, _} ->
        true

      {_, 0} ->
        false

      _ ->
        l = MapSet.to_list(todo)
        [first] = Enum.take(l, 1)
        remaining = Enum.slice(l, 1..-1)

        new_vertices =
          Map.get(vertices, first)
          |> MapSet.difference(todo)
          |> MapSet.difference(done)

        new_todo = MapSet.new(remaining) |> MapSet.union(new_vertices)
        new_done = MapSet.put(done, first)

        are_connected?(vertices, dest, new_todo, new_done)
    end
  end

  def add_route(%Graph{vertices: vertices}, [from, to]) do
    from_vertex = Map.get(vertices, from)
    to_vertex = Map.get(vertices, to)

    updated_vertices =
      vertices
      |> Map.put(from, MapSet.put(from_vertex, to))
      |> Map.put(to, MapSet.put(to_vertex, from))

    %Graph{vertices: updated_vertices}
  end
end

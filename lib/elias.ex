defmodule Elias do
  alias Elias.AST
  alias Elias.Merge
  alias Elias.Parser

  @doc """
  Parse an Elias string into a single map
  """
  def parse(string) do
    case Parser.parse(string) do
      {:ok, ast} ->
        ast
        |> AST.walk()
        |> Merge.collapse()
    end
  end
end

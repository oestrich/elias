defmodule UCL do
  alias UCL.AST
  alias UCL.Merge
  alias UCL.Parser

  @doc """
  Parse an UCL string into a single map
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

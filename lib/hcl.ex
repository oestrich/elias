defmodule HCL do
  alias HCL.AST
  alias HCL.Merge
  alias HCL.Parser

  @doc """
  Parse an HCL string into a single map
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

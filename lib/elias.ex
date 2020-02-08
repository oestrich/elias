defmodule Elias do
  @moduledoc """
  Elias is a UCL parser

  [Universal Configuration Language](https://github.com/vstakhov/libucl)
  """

  alias Elias.AST
  alias Elias.Merge
  alias Elias.Parser

  @doc """
  Parse an UCL string into a map
  """
  @spec parse(String.t()) :: map()
  def parse(string) do
    case Parser.parse(string) do
      {:ok, ast} ->
        ast
        |> AST.walk()
        |> Merge.collapse()
    end
  end
end

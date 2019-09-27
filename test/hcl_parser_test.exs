defmodule HCL.ParserTest do
  use ExUnit.Case

  alias HCL.Parser

  test "simple object" do
    string = """
    rooms "town_square" {
      name = "Town's Square"
    }
    """

    {:ok, ast} = Parser.parse(string)

    IO.inspect ast
  end
end

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

  test "simple object with multiple values" do
    string = """
    rooms "town_square" {
      name = "Town's Square"
      description = "A town square"
    }
    """

    {:ok, ast} = Parser.parse(string)

    IO.inspect ast
  end

  test "mutliple simple objects" do
    string = """
    rooms "town_square" {
      name = "Town's Square"
    }

    rooms "marketplace" {
      name = "Marketplace"
    }
    """

    {:ok, ast} = Parser.parse(string)

    IO.inspect ast
  end

  test "simple object with empty line" do
    string = """
    rooms "town_square" {
      name = "Town's Square"

      description = "A town square"
    }
    """

    {:ok, ast} = Parser.parse(string)

    IO.inspect ast
  end

  describe "arrays" do
    test "array with one element" do
      string = """
      rooms "town_square" {
        features = [
          {
            name = "sign"
          }
        ]
      }
      """

      {:ok, ast} = Parser.parse(string)

      IO.inspect ast
    end

    test "multiple elements" do
      string = """
      rooms "town_square" {
        features = [
          {
            name = "sign"
          },
          {
            name = "well"
          }
        ]
      }
      """

      {:ok, ast} = Parser.parse(string)

      IO.inspect ast
    end
  end
end

defmodule HCL.ParserTest do
  use ExUnit.Case

  alias HCL.Parser

  describe "the basics" do
    test "simple object" do
      string = """
      rooms "town_square" {
        name = "Town's Square"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:object, [string: ['rooms'], string: ['town_square']],
                {:block, [{:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}}]}}
             ]
    end

    test "simple object with multiple values" do
      string = """
      rooms "town_square" {
        name = "Town's Square"
        description = "A town square"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:object, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}},
                   {:assignment, 'description', {:string, ['A', ' ', 'town', ' ', 'square']}}
                 ]}}
             ]
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

      assert ast == [
               {:object, [string: ['rooms'], string: ['town_square']],
                {:block, [{:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}}]}},
               {:object, [string: ['rooms'], string: ['marketplace']],
                {:block, [{:assignment, 'name', {:string, ['Marketplace']}}]}}
             ]
    end

    test "simple object with empty line" do
      string = """
      rooms "town_square" {
        name = "Town's Square"

        description = "A town square"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:object, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}},
                   {:assignment, 'description', {:string, ['A', ' ', 'town', ' ', 'square']}}
                 ]}}
             ]
    end
  end

  describe "integers" do
    test "parses" do
      string = """
      rooms "town_square" {
        id = 10
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:object, [string: ['rooms'], string: ['town_square']],
                {:block, [{:assignment, 'id', {:integer, 10}}]}}
             ]
    end
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

      assert ast == [
               {:object, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'features',
                    {:array, [block: [{:assignment, 'name', {:string, ['sign']}}]]}}
                 ]}}
             ]
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

      assert ast == [
               {:object, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'features',
                    {:array,
                     [
                       block: [{:assignment, 'name', {:string, ['sign']}}],
                       block: [{:assignment, 'name', {:string, ['well']}}]
                     ]}}
                 ]}}
             ]
    end
  end
end

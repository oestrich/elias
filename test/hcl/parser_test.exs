defmodule HCL.ParserTest do
  use ExUnit.Case

  alias HCL.Parser

  describe "the basics" do
    test "simple section" do
      string = """
      rooms "town_square" {
        name = "Town's Square"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block, [{:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}}]}}
             ]
    end

    test "simple section with multiple values" do
      string = """
      rooms "town_square" {
        name = "Town's Square"
        description = "A town square"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}},
                   {:assignment, 'description', {:string, ['A', ' ', 'town', ' ', 'square']}}
                 ]}}
             ]
    end

    test "mutliple simple sections" do
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
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block, [{:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}}]}},
               {:section, [string: ['rooms'], string: ['marketplace']],
                {:block, [{:assignment, 'name', {:string, ['Marketplace']}}]}}
             ]
    end

    test "simple section with empty line" do
      string = """
      rooms "town_square" {
        name = "Town's Square"

        description = "A town square"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}},
                   {:assignment, 'description', {:string, ['A', ' ', 'town', ' ', 'square']}}
                 ]}}
             ]
    end

    test "allows semi colons" do
      string = """
      rooms "town_square" {
        name = "Town's Square";
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block, [{:assignment, 'name', {:string, ['Town', '\'', 's', ' ', 'Square']}}]}}
             ]
    end

    test "use equals with blocks" do
      string = """
      rooms "town_square" {
        features = {
          key = "sign"
        }
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:section, [string: 'features'],
                    {:block, [{:assignment, 'key', {:string, ['sign']}}]}}
                 ]}}
             ]
    end

    test "sections and assignments" do
      string = """
      rooms "town_square" {
        features = {
          key : "sign"
        }
        features= {
          key: "sign"
        }
        features ={
          key :"sign"
        }
        features={
          key:"sign"
        }
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:section, [string: 'features'],
                    {:block, [{:assignment, 'key', {:string, ['sign']}}]}},
                   {:section, [string: 'features'],
                    {:block, [{:assignment, 'key', {:string, ['sign']}}]}},
                   {:section, [string: 'features'],
                    {:block, [{:assignment, 'key', {:string, ['sign']}}]}},
                   {:section, [string: 'features'],
                    {:block, [{:assignment, 'key', {:string, ['sign']}}]}}
                 ]}}
             ]
    end

    test "including a root object" do
      string = """
      {
        rooms "town_square" {
          name = "Town Square"
        }
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'name', {:string, ['Town', ' ', 'Square']}}
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
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block, [{:assignment, 'id', {:integer, 10}}]}}
             ]
    end
  end

  describe "arrays" do
    test "auto creates arrays" do
      string = """
      rooms "town_square" {
        feature {
          name = "sign"
        }

        feature {
          name = "sign"
        }
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:section, [string: ['feature']],
                    {:block, [{:assignment, 'name', {:string, ['sign']}}]}},
                   {:section, [string: ['feature']],
                    {:block, [{:assignment, 'name', {:string, ['sign']}}]}}
                 ]}}
             ]
    end

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
               {:section, [string: ['rooms'], string: ['town_square']],
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
               {:section, [string: ['rooms'], string: ['town_square']],
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

defmodule Elias.ParserTest do
  use ExUnit.Case

  alias Elias.Parser

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

    test "keys can have integers" do
      string = """
      rooms "town_square0" {
        name = "Town Square"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square', '0']],
                {:block,
                 [
                   {:assignment, 'name', {:string, ['Town', ' ', 'Square']}}
                 ]}}
             ]
    end

    test "escaped values" do
      string = """
      rooms "town_square" {
        regex = "\\bHello\\b"
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['rooms'], string: ['town_square']],
                {:block,
                 [
                   {:assignment, 'regex', {:string, ['\\', 'bHello', '\\', 'b']}}
                 ]}}
             ]
    end

    test "plain values can have dashes" do
      string = """
      room_exits "path-1" {
        room_id = rooms.path-1.id

        south = other-zone.rooms.entrance.id
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {
                 :section,
                 [string: ['room_exits'], string: ['path', '-', '1']],
                 {:block,
                  [
                    {:assignment, 'room_id', {:value, 'rooms.path-1.id'}},
                    {:assignment, 'south', {:value, 'other-zone.rooms.entrance.id'}}
                  ]}
               }
             ]
    end

    test "string values with escaped quotes" do
      string = """
      data = {
        channel_name = "characters:${character.id}"
        text = "Hello, we have a {color foreground='white'}bandit{/color} problem."
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {
                 :section,
                 [{:string, 'data'}],
                 {
                   :block,
                   [
                     {:assignment, 'channel_name',
                      {:string, ['characters', ':', '$', '{', 'character.id', '}']}},
                     {:assignment, 'text',
                      {:string,
                       [
                         'Hello,',
                         ' ',
                         'we',
                         ' ',
                         'have',
                         ' ',
                         'a',
                         ' ',
                         '{',
                         'color',
                         ' ',
                         'foreground',
                         '=',
                         '\'',
                         'white',
                         '\'',
                         '}',
                         'bandit',
                         '{',
                         '/',
                         'color',
                         '}',
                         ' ',
                         'problem.'
                       ]}}
                   ]
                 }
               }
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

    test "array with no elements" do
      string = """
      rooms "town_square" {
        features = [
        ]

        characters = []
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {
                 :section,
                 [string: ['rooms'], string: ['town_square']],
                 {:block,
                  [
                    {:assignment, 'features', {:array, []}},
                    {:assignment, 'characters', {:array, []}}
                  ]}
               }
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

  describe "comments" do
    test "single line" do
      string = """
      # Comments
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:comments, [' ', 'Comments']}
             ]
    end

    test "multi-line" do
      string = """
      /* Comments
        on multiple "lines"
      *
      # Tossing in extra \ / characters
       */
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:comments,
                [
                  ' ',
                  'Comments',
                  '\n',
                  '  ',
                  'on',
                  ' ',
                  'multiple',
                  ' ',
                  '"',
                  'lines',
                  '"',
                  '\n',
                  '*',
                  '\n',
                  '#',
                  ' ',
                  'Tossing',
                  ' ',
                  'in',
                  ' ',
                  'extra',
                  '  ',
                  '/',
                  ' ',
                  'characters',
                  '\n',
                  ' '
                ]}
             ]
    end

    test "can use parts of the comment inside strings" do
      string = """
      name = "Forward /"
      name = "Star *"
      name = "Both /*"
      name = "Pound #"
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:assignment, 'name', {:string, ['Forward', ' ', '/']}},
               {:assignment, 'name', {:string, ['Star', ' ', '*']}},
               {:assignment, 'name', {:string, ['Both', ' ', '/*']}},
               {:assignment, 'name', {:string, ['Pound', ' ', '#']}}
             ]
    end

    test "comments in arrays" do
      string = """
      rooms "town_square" {
        features = [
          # A sign
          { name = "sign" },
          # Another one
          { name = "sign" }
          # Comment at the end
        ]

        other = [
          # comments
        ]
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {
                 :section,
                 [{:string, ['rooms']}, {:string, ['town_square']}],
                 {:block,
                  [
                    {:assignment, 'features',
                     {:array,
                      [
                        comments: [' ', 'A', ' ', 'sign'],
                        block: [{:assignment, 'name', {:string, ['sign']}}],
                        comments: [' ', 'Another', ' ', 'one'],
                        block: [{:assignment, 'name', {:string, ['sign']}}]
                      ]}},
                    {:assignment, 'other', {:array, []}}
                  ]}
               }
             ]
    end

    test "non objects in arrays" do
      string = """
      array = [
        "sign",5,
        true
      ]
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:assignment, 'array',
                {:array,
                 [
                   {:string, ['sign']},
                   {:integer, 5},
                   {:value, 'true'}
                 ]}}
             ]
    end
  end

  describe "variables" do
    test "does not require quotes around strings" do
      string = """
      room_exits "town_square" {
        room_id = rooms.town_square.id
      }
      """

      {:ok, ast} = Parser.parse(string)

      assert ast == [
               {:section, [string: ['room_exits'], string: ['town_square']],
                {:block, [{:assignment, 'room_id', {:value, 'rooms.town_square.id'}}]}}
             ]
    end
  end
end

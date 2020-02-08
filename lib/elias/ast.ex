defmodule Elias.AST do
  @moduledoc """
  Process a raw AST into Elixir structs
  """

  @doc """
  Walk an AST and transform into known nodes
  """
  def walk(ast), do: walk_ast(ast)

  @doc false
  def walk_ast([]), do: []

  def walk_ast([node | nodes]) do
    [parse_node(node) | walk_ast(nodes)]
  end

  @doc """
  Convert a single AST tuple into a struct
  """
  def parse_node({:section, key, section}) do
    %Elias.Section{
      key: walk_key(key),
      block: parse_node(section)
    }
  end

  def parse_node({:block, expressions}) do
    walk_ast(expressions)
  end

  def parse_node({:assignment, key, value}) do
    %Elias.Value{
      key: String.to_atom(to_string(key)),
      value: parse_value(value)
    }
  end

  def parse_node({:comments, comments}) do
    %Elias.Comments{
      text: comments
    }
  end

  @doc """
  Parse assignment values into a struct or plain value
  """
  def parse_value({:array, expressions}), do: walk_ast(expressions)

  def parse_value({:block, expressions}), do: parse_node({:block, expressions})

  def parse_value({:integer, integer}), do: integer

  def parse_value({:string, strings}) do
    strings
    |> Enum.map(&to_string/1)
    |> Enum.join()
    |> unescape_quotes()
  end

  def parse_value({:value, word}) do
    to_string(word)
  end

  @doc false
  def unescape_quotes(string) do
    string
    |> String.replace("\\\"", "\"")
    |> String.replace("\\'", "'")
  end

  @doc false
  def walk_key(strings) do
    Enum.map(strings, fn {:string, string} ->
      String.to_atom(to_string(string))
    end)
  end
end

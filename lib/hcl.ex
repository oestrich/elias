defmodule HCL.Object do
  defstruct [:key, :block]
end

defmodule HCL.Block do
  defstruct [:data]
end

defmodule HCL.Value do
  defstruct [:key, :value]
end

defmodule HCL.Parser do
  def parse(string) do
    case :hcl_lexer.string(String.to_charlist(string)) do
      {:ok, tokens, _} ->
        parse_tokens(tokens)
    end
  end

  def parse_tokens(tokens) do
    case :hcl_parser.parse(tokens) do
      {:ok, tokens} ->
        {:ok, tokens}
    end
  end
end

defmodule HCL do
  def parse(string) do
    case :hcl_lexer.string(String.to_charlist(string)) do
      {:ok, tokens, _} ->
        parse_tokens(tokens)
    end
  end

  def parse_tokens(tokens) do
    case :hcl_parser.parse(tokens) do
      {:ok, ast} ->
        ast
        |> walk_ast()
        |> HCL.CollapseAST.collapse()
    end
  end

  def walk_ast([]), do: []

  def walk_ast([node | nodes]) do
    [parse_node(node) | walk_ast(nodes)]
  end

  def parse_node({:object, key, object}) do
    %HCL.Object{
      key: walk_key(key),
      block: parse_node(object)
    }
  end

  def parse_node({:block, expressions}) do
    walk_ast(expressions)
  end

  def parse_node({:assignment, key, value}) do
    %HCL.Value{
      key: String.to_atom(to_string(key)),
      value: parse_value(value)
    }
  end

  def parse_value({:array, expressions}) do
    walk_ast(expressions)
  end

  def parse_value({:string, strings}) do
    strings
    |> Enum.map(&to_string/1)
    |> Enum.join()
    |> unescape_quotes()
  end

  def unescape_quotes(string) do
    string
    |> String.replace("\\\"", "\"")
    |> String.replace("\\'", "'")
  end

  def walk_key(strings) do
    Enum.map(strings, fn {:string, string} ->
      String.to_atom(to_string(string))
    end)
  end
end

defmodule HCL.CollapseAST do
  def collapse(objects) do
    Enum.reduce(objects, %{}, fn object, map ->
      merge_object(object.key, object.block, map)
    end)
  end

  def reduce_value(%{key: key, value: values}, map) when is_list(values) do
    Map.put(map, key, reduce_array(values))
  end

  def reduce_value(%{key: key, value: value}, map) do
    Map.put(map, key, value)
  end

  def reduce_array(values) do
    Enum.map(values, fn block ->
      Enum.reduce(block, %{}, fn value, map ->
        Map.put(map, value.key, value.value)
      end)
    end)
  end

  def merge_object([key], value, map) do
    data = Enum.reduce(value, %{}, &reduce_value/2)
    Map.put(map, key, data)
  end

  def merge_object([key | keys], value, map) do
    sub_map = Map.get(map, key, %{})
    sub_map = merge_object(keys, value, sub_map)
    Map.put(map, key, sub_map)
  end
end

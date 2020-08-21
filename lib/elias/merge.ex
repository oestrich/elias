defmodule Elias.Merge do
  @moduledoc """
  Merge an AST into a map
  """

  alias Elias.Comments
  alias Elias.Section
  alias Elias.Variable

  @doc """
  Merge a set of sections into a single map
  """
  def collapse(assigments) do
    Enum.reduce(assigments, %{}, &reduce_assignment/2)
  end

  @doc false
  def append_value(map, key, value) do
    case Map.has_key?(map, key) do
      true ->
        existing = List.wrap(map[key])
        existing = Enum.reverse(existing)
        Map.put(map, key, Enum.reverse([value | existing]))

      false ->
        Map.put(map, key, value)
    end
  end

  @doc false
  def reduce_assignment(value = %Variable{}, map) do
    append_value(map, value.key, value.value)
  end

  def reduce_assignment(section = %Section{}, map) do
    merge_section(section.key, section.block, map)
  end

  def reduce_assignment(_comments = %Comments{}, map), do: map

  @doc false
  def reduce_value(section = %Section{}, map) do
    merge_section(section.key, section.block, map)
  end

  def reduce_value(_comments = %Comments{}, map), do: map

  def reduce_value(%{key: key, value: values}, map) when is_list(values) do
    append_value(map, key, reduce_array(values))
  end

  def reduce_value(%{key: key, value: value}, map) do
    append_value(map, key, value)
  end

  @doc false
  def reduce_array(values) do
    values
    |> Enum.map(&map_array_item/1)
    |> Enum.reject(&is_nil/1)
  end

  @doc false
  def map_array_item(value = %Elias.Value{}), do: value.data

  def map_array_item(%Elias.Comments{}), do: nil

  def map_array_item(block) do
    Enum.reduce(block, %{}, fn value, map ->
      reduce_value(value, map)
    end)
  end

  @doc false
  def merge_section([key], value, map) do
    data = Enum.reduce(value, %{}, &reduce_value/2)
    append_value(map, key, data)
  end

  def merge_section([key | keys], value, map) do
    sub_map = Map.get(map, key, %{})
    sub_map = merge_section(keys, value, sub_map)
    Map.put(map, key, sub_map)
  end
end

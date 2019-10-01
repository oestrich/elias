defmodule HCL.Merge do
  @moduledoc """
  Merge an AST into a map
  """

  alias HCL.Section
  alias HCL.Value

  @doc """
  Merge a set of sections into a single map
  """
  def collapse(assigments) do
    Enum.reduce(assigments, %{}, &reduce_assignment/2)
  end

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

  def reduce_assignment(value = %Value{}, map) do
    append_value(map, value.key, value.value)
  end

  def reduce_assignment(section = %Section{}, map) do
    merge_section(section.key, section.block, map)
  end

  def reduce_value(section = %Section{}, map) do
    merge_section(section.key, section.block, map)
  end

  def reduce_value(%{key: key, value: values}, map) when is_list(values) do
    append_value(map, key, reduce_array(values))
  end

  def reduce_value(%{key: key, value: value}, map) do
    append_value(map, key, value)
  end

  def reduce_array(values) do
    Enum.map(values, fn block ->
      Enum.reduce(block, %{}, fn value, map ->
        append_value(map, value.key, value.value)
      end)
    end)
  end

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

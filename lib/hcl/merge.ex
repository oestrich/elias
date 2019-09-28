defmodule HCL.Merge do
  @moduledoc """
  Merge an AST into a map
  """

  @doc """
  Merge a set of objects into a single map
  """
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

defmodule HclTest do
  use ExUnit.Case
  doctest Hcl

  test "greets the world" do
    assert Hcl.hello() == :world
  end
end

defmodule FlareTest do
  use ExUnit.Case
  doctest Flare

  test "greets the world" do
    assert Flare.hello() == :world
  end
end

defmodule PatreonTest do
  use ExUnit.Case
  doctest Patreon

  test "greets the world" do
    assert Patreon.hello() == :world
  end
end

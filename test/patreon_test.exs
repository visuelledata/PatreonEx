defmodule PatreonExTest do
  use ExUnit.Case, async: true
  doctest PatreonEx

  test "greets the world" do
    assert PatreonEx.hello() == :world
  end
end

defmodule Gw2ApiTest do
  use ExUnit.Case
  doctest Gw2Api

  test "greets the world" do
    assert Gw2Api.hello() == :world
  end
end

defmodule DistAppTest do
  use ExUnit.Case
  doctest DistApp

  test "greets the world" do
    assert DistApp.hello() == :world
  end
end

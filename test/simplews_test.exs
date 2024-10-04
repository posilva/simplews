defmodule SimplewsTest do
  use ExUnit.Case
  doctest Simplews

  test "greets the world" do
    assert Simplews.hello() == :world
  end
end

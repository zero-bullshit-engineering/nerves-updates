defmodule FwuppocTest do
  use ExUnit.Case
  doctest Fwuppoc

  test "greets the world" do
    assert Fwuppoc.hello() == :world
  end
end

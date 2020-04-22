defmodule BehaviourIntrospectionTest do
  use ExUnit.Case
  doctest BehaviourIntrospection

  test "greets the world" do
    assert BehaviourIntrospection.hello() == :world
  end
end

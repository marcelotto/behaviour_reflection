defmodule Behaviour.ReflectionTest do
  use ExUnit.Case
  doctest Behaviour.Reflection

  defmodule Dynamic.Foo do
    @behaviour Test.Behaviour
    def fun, do: "dynamic foo"
  end

  defmodule Dynamic.Bar do
    @behaviour Test.Behaviour
    @behaviour Test.OtherBehaviour
    def fun, do: "dynamic bar"
    def other_fun, do: "dynamic bar"
  end

  test "impls" do
    assert Behaviour.Reflection.impls(Test.Behaviour) |> MapSet.new() ==
             [Dynamic.Foo, Dynamic.Bar, Static.Foo, Static.Bar] |> MapSet.new()

    assert Behaviour.Reflection.impls(Test.OtherBehaviour) |> MapSet.new() ==
             [Dynamic.Bar, Static.Bar] |> MapSet.new()
  end

  test "impls with :code_all_loaded" do
    # Static modules are non-deterministically detected
    assert Dynamic.Foo in Behaviour.Reflection.impls(Test.Behaviour, :code_all_loaded)
    assert Dynamic.Bar in Behaviour.Reflection.impls(Test.Behaviour, :code_all_loaded)
    assert Dynamic.Bar in Behaviour.Reflection.impls(Test.OtherBehaviour, :code_all_loaded)
  end

  test "impls with :beam_file_analysis" do
    assert Behaviour.Reflection.impls(Test.Behaviour, :beam_file_introspection) |> MapSet.new() ==
             [Static.Foo, Static.Bar] |> MapSet.new()

    assert Behaviour.Reflection.impls(Test.OtherBehaviour, :beam_file_introspection)
           |> MapSet.new() ==
             [Static.Bar] |> MapSet.new()
  end
end

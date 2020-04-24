defmodule Behaviour.IntrospectionTest do
  use ExUnit.Case
  doctest Behaviour.Introspection

  defmodule Bar do
    @behaviour Test.Behaviour
    def fun, do: "bar"
  end

  test "impls" do
    assert Behaviour.Introspection.impls(Test.Behaviour) == [Bar, Test.Foo]
  end

  test "impls with :code_all_loaded" do
    # Test.Foo is non-deterministically detected
    assert Bar in Behaviour.Introspection.impls(Test.Behaviour, :code_all_loaded)
  end

  test "impls with :beam_file_analysis" do
    assert Behaviour.Introspection.impls(Test.Behaviour, :beam_file_introspection) == [Test.Foo]
  end
end

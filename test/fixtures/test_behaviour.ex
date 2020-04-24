defmodule Test.Behaviour do
  @callback fun :: String.t()
end

defmodule Test.Foo do
  @behaviour Test.Behaviour
  def fun(), do: "foo"
end

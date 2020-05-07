defmodule Test.Behaviour do
  @callback fun :: String.t()
end

defmodule Test.OtherBehaviour do
  @callback other_fun :: String.t()
end

defmodule Static.Foo do
  @behaviour Test.Behaviour
  def fun(), do: "static foo"
end

defmodule Static.Bar do
  @behaviour Test.Behaviour
  @behaviour Test.OtherBehaviour
  def fun, do: "static bar"
  def other_fun, do: "static bar"
end

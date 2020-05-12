# Behaviour.Reflection

Get all modules implementing an Elixir behaviour.


## Installation

The Hex package can be installed as usual, by adding `behaviour_reflection` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:behaviour_reflection, "~> 0.1"}
  ]
end
```


## Usage

Let's say you have a behaviour and a number of modules implementing it:

```elixir
defmodule MyBehaviour do
  @callback fun :: String.t
end

defmodule Foo do
  @behaviour MyBehaviour
  def fun(), do: "foo"
end

defmodule Bar do
  @behaviour MyBehaviour
  def fun(), do: "bar"
end
```

At runtime you can retrieve all modules implementing the behaviour like this:

```elixir
iex> Behaviour.Reflection.impls(MyBehaviour)
[Foo, Bar]
```

Documentation can be found at [https://hexdocs.pm/behaviour_reflection](https://hexdocs.pm/behaviour_reflection).

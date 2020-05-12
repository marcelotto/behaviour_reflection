# Behaviour.Reflection

[![Travis](https://img.shields.io/travis/marcelotto/behaviour_reflection.svg?style=flat-square)](https://travis-ci.org/marcelotto/behaviour_reflection)
[![Hex.pm](https://img.shields.io/hexpm/v/behaviour_reflection.svg?style=flat-square)](https://hex.pm/packages/behaviour_reflection)


Get all modules implementing an Elixir behaviour.

See [this article](https://medium.com/@MarcelOttoDE/the-walled-gardens-within-elixir-d0507a568015) for an analysis of the problem, the circumstances for when to use this library, how it works and its caveats.


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

defmodule BehaviourReflection.MixProject do
  use Mix.Project

  @repo_url "https://github.com/marcelotto/behaviour_reflection"

  @version "0.1.0"

  def project do
    [
      app: :behaviour_reflection,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),

      # Hex
      package: package(),
      description: description(),

      # Docs
      name: "Behaviour.Reflection",
      source_url: @repo_url,
      docs: [
        main: "Behaviour.Reflection",
        source_ref: "v#{@version}",
        extras: ["CHANGELOG.md"]
      ]
    ]
  end

  defp description do
    """
    Get all modules implementing an Elixir behaviour.
    """
  end

  defp package do
    [
      maintainers: ["Marcel Otto"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url,
        "Changelog" => @repo_url <> "/blob/master/CHANGELOG.md"
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/fixtures"]
  defp elixirc_paths(_), do: ["lib"]
end

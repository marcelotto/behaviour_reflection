defmodule Behaviour.Reflection do
  @moduledoc """
  Find all modules implementing a Behaviour.
  """

  @doc """
  Find and load all modules implementing the given Behaviour.

  Several methods to detect implementations can be applied:

  - `:beam_file_introspection`: filters all modules in `.beam` files of the
    Mix project implementing `behaviour`
  - `:code_all_loaded`: filters all modules  returned by `:code.all_loaded/0`
    the implementing `behaviour`

  Unless otherwise specified with the optional `impl_detection_methods` argument,
  both methods are applied when the BEAM is running in interactive mode (which is
  the default). In embedded mode (which is used in releases), only the `:code_all_loaded`
  method and should be sufficient since the boot script loads all modules upfront.
  """
  def impls(behaviour, impl_detection_methods \\ nil)

  def impls(behaviour, nil) do
    impls(
      behaviour,
      case :code.get_mode() do
        :interactive -> ~w(beam_file_introspection code_all_loaded)a
        :embedded -> :code_all_loaded
      end
    )
  end

  def impls(behaviour, impl_detection_methods) when is_list(impl_detection_methods) do
    impl_detection_methods
    |> Enum.reduce(MapSet.new(), fn impl_detection_method, results ->
      impls(behaviour, impl_detection_method)
      |> MapSet.new()
      |> MapSet.union(results)
    end)
    |> MapSet.to_list()
  end

  def impls(behaviour, :beam_file_introspection) when is_atom(behaviour) do
    if mix_available?() do
      behaviour
      |> impls_from_beam_files()
      |> Enum.reduce([], &load_module/2)
    else
      []
    end
  end

  def impls(behaviour, :code_all_loaded) when is_atom(behaviour) do
    :code.all_loaded()
    |> Enum.map(fn {module, _} -> module end)
    |> Enum.filter(&implements_behaviour?(&1, behaviour))
  end

  defp implements_behaviour?(module, behaviour) do
    module.module_info[:attributes]
    |> Keyword.get_values(:behaviour)
    |> List.flatten()
    |> Enum.member?(behaviour)
  end

  # from https://stackoverflow.com/a/36435699/2114405
  defp impls_from_beam_files(behaviour) do
    # Ensure the current projects code path is loaded
    Mix.Task.run("loadpaths", [])
    # Fetch all .beam files
    Path.wildcard(Path.join([Mix.Project.build_path(), "**/ebin/**/*.beam"]))
    # Parse the BEAM for behaviour implementations
    |> Stream.map(fn path ->
      {:ok, {mod, chunks}} = :beam_lib.chunks('#{path}', [:attributes])
      {mod, get_in(chunks, [:attributes, :behaviour])}
    end)
    # Filter out behaviours we don't care about and duplicates
    |> Stream.filter(fn {_mod, behaviours} -> is_list(behaviours) && behaviour in behaviours end)
    |> Enum.uniq()
    |> Enum.map(fn {module, _} -> module end)
  end

  defp load_module(module, modules) do
    if Code.ensure_loaded?(module), do: [module | modules], else: modules
  end

  defp mix_available? do
    not is_nil(Process.whereis(Mix.ProjectStack))
  end
end

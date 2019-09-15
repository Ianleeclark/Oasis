defmodule Oasis do
  @moduledoc """
  Documentation for Oasis.
  """

  alias Oasis.Parser
  alias Oasis.Parser.Metadata

  def create_x(filename) do
    # TODO(ian): Can we use `defoverridable` to make these dynamically defined and swap out modules at runtime
    {:ok, metadata_by_opids} =
      filename
      |> File.read!()
      |> Jason.decode!()
      |> Parser.load()

    contents =
      quote(
        bind_quoted: [metadata_by_opids: metadata_by_opids |> Macro.escape()],
        unquote: true
      ) do
        # TODO(ian): tighten up the retval
        @spec _call(
                uri :: String.t(),
                http_method :: atom(),
                data :: map() | nil,
                headers :: list(),
                opts :: list
              ) :: any()
        def _call(uri, http_method, data, headers, opts) do
        end

        unquote do
          Enum.map(metadata_by_opids, fn {opid, %Metadata{} = metadata} ->
            create_function(opid, metadata)
          end)
        end
      end

    Module.create(Oasis.Endpoints, contents, __ENV__)
  end

  def create_function(function_name, %Metadata{uri: uri, method: method}) do
    quote do
      @doc """
      Auto-generated from Oasis.
      """
      # TODO(ian): Change the `any` response
      @spec unquote(function_name |> String.to_atom())(
              data :: map(),
              headers :: list(),
              opts :: list
            ) :: any()
      def unquote(function_name |> String.to_atom())(data \\ nil, headers \\ [], opts \\ []) do
        _call(unquote(uri), unquote(method), data, headers, opts)
      end
    end
  end
end

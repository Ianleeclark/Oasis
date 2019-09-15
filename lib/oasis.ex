defmodule Oasis do
  @moduledoc """
  Documentation for Oasis.
  """

  alias Oasis.Parser
  alias Oasis.Parser.Metadata

  @http Application.get_env(:oasis, :http_module)

  # TODO(ian): Typespec
  defp register_endpoints_from_filename(filename) do
    # TODO(ian): Can we use `defoverridable` to make these dynamically defined and swap out modules at runtime
    {:ok, metadata_by_opids} =
      filename
      |> File.read!()
      |> Jason.decode!()
      |> Parser.load()

    contents =
      quote(
        bind_quoted: [
          metadata_by_opids: metadata_by_opids |> Macro.escape(),
          http_interface: @http
        ],
        unquote: true
      ) do
        # TODO(ian): tighten up the retval
        @spec _call(
                uri :: String.t(),
                http_method :: atom(),
                schema :: map(),
                data :: map() | nil,
                headers :: list(),
                opts :: list
              ) :: any()

        # TODO(ian): Document this
        def _call(uri, http_method, schema, data, headers, opts) do
          with :ok <- schema.validate_input(data) do
            Map.get(http_interface, http_method).(data, headers, opts)
          end
        end

        unquote do
          Enum.map(metadata_by_opids, fn {opid, %Metadata{} = metadata} ->
            create_function(opid, metadata)
          end)
        end
      end

    Module.create(Oasis.Endpoints, contents, __ENV__)
  end

  defp create_function(function_name, %Metadata{uri: uri, method: method, schema: schema}) do
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
        _call(unquote(uri), unquote(method), unquote(schema), data, headers, opts)
      end
    end
  end
end

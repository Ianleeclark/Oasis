defmodule Oasis do
  @moduledoc """
  Documentation for Oasis.
  """

  alias Oasis.HTTPSpec
  alias Oasis.Parser
  alias Oasis.Parser.Metadata

  @http Application.get_env(:oasis, :http_module)

  @spec register_endpoints_from_filename(filename :: Path.t()) ::
          {:module, module(), binary(), term()}
  def register_endpoints_from_filename(filename) do
    # NOTE(ian): Can we use `defoverridable` to make these dynamically defined and swap out modules at runtime
    {:ok, metadata_by_opids} =
      filename
      |> File.read!()
      |> Parser.load()

    # Contents are the AST of the module. There are two things of note here:
    # 1.) `call/6` which handles sending requests
    # 2.) Any additional function generated from `generate_function/2`.
    contents =
      quote(
        bind_quoted: [
          metadata_by_opids: metadata_by_opids |> Macro.escape(),
          http_interface: @http
        ],
        unquote: true
      ) do
        @http_interface http_interface

        @spec call(
                uri :: String.t(),
                http_method :: atom(),
                schema :: map(),
                data :: map() | nil,
                headers :: list(),
                opts :: list()
              ) :: HTTPSpec.response()
        defp call(uri, http_method, schema, data \\ nil, headers \\ [], opts \\ []) do
          # Only a few of these need bodies.
          args =
            if Enum.member?([:put, :patch, :post], http_method) do
              [uri, data, headers, opts]
            else
              [uri, headers, opts]
            end

          apply(@http_interface, http_method, args)
        end

        # Iterate through the metadata creating a function per `operation_id`
        unquote do
          Enum.map(metadata_by_opids, fn {opid, %Metadata{} = metadata} ->
            create_function(opid, metadata)
          end)
        end
      end

    Module.create(Oasis.Endpoints, contents, __ENV__)
  end

  #########################################################################################
  # Creates an injectable function to be added to the `Oasis.Endpoints` module.           #
  #                                                                                       #
  # These are intermediary functions that hold metadata for the `call/6` method. Instead  #
  # of having the caller need to pass in the http method, the URI, and the schema per     #
  # call, we have this method hold onto that data, so the caller is only required to pass #
  # in `data`, `headers`, and `opts`, thus satisfying the `HTTPSpec`                      #
  #########################################################################################
  @spec create_function(function_name :: String.t(), Metadata.t()) :: any()
  defp create_function(function_name, %Metadata{uri: uri, method: method, schema: schema}) do
    quote do
      @doc """
      Auto-generated from Oasis.
      """
      @spec unquote(function_name |> String.to_atom())(
              data :: map(),
              headers :: list(),
              opts :: list
            ) :: HTTPSpec.response()
      def unquote(function_name |> String.to_atom())(data \\ nil, headers \\ [], opts \\ []) do
        call(
          unquote(uri),
          unquote(method),
          # NOTE: The macro.escape may not be necessary when this is an ecto schema
          unquote(schema |> Macro.escape()),
          data,
          headers,
          opts
        )
      end
    end
  end
end

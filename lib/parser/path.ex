defmodule Oasis.Parser.Path do
  @moduledoc """
  Represents a Path from OAS 3.0

  See also: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#pathItemObject
  """

  alias Oasis.Parser.Operation

  @required_keys [:uri, :get, :put, :post, :delete, :patch, :head, :options, :trace, :parameters]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          uri: String.t(),
          get: Operation.t(),
          put: Operation.t(),
          post: Operation.t(),
          delete: Operation.t(),
          patch: Operation.t(),
          head: Operation.t(),
          options: Operation.t(),
          trace: Operation.t(),
          parameters: [map()]
        }

  def new(
        uri,
        get \\ nil,
        put \\ nil,
        post \\ nil,
        delete \\ nil,
        patch \\ nil,
        head \\ nil,
        options \\ nil,
        trace \\ nil,
        parameters \\ []
      )
      when is_binary(uri) do
    %__MODULE__{
      uri: uri,
      get: Operation.from_map(get),
      put: Operation.from_map(put),
      post: Operation.from_map(post),
      delete: Operation.from_map(delete),
      patch: Operation.from_map(patch),
      head: Operation.from_map(head),
      options: Operation.from_map(options),
      trace: Operation.from_map(trace),
      parameters: Operation.from_map(parameters)
    }
  end

  @doc """
  Converts a map into a `t:Path.t()/0`
  """
  @spec from_map(uri :: String.t(), json :: %{String.t() => any()}) :: t()
  def from_map(uri, json) when is_binary(uri) and is_map(json) do
    new(
      uri,
      json["get"],
      json["put"],
      json["post"],
      json["delete"],
      json["patch"],
      json["head"],
      json["options"],
      json["trace"],
      json["parameters"]
    )
  end

  @doc """
  A helper method to easily list all expected HTTP methods.
  """
  @spec all_http_methods() :: [atom()]
  def all_http_methods, do: [:get, :put, :post, :delete, :patch, :head, :options, :trace]
end

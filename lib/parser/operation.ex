defmodule Oasis.Parser.Operation do
  @moduledoc """
  Represents an Operation from OAS 3.0

  See also: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#operationObject
  """

  import Oasis.Utils.Guards
  alias Oasis.Parser.{Reference, RequestBody}

  @required_keys [
    :operation_id,
    :parameters,
    :request_body,
    :responses,
    :callbacks,
    :deprecated?,
    :security,
    :requires_auth?
  ]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          operation_id: String.t(),
          parameters: [map()],
          request_body: Reference.t() | RequestBody.t() | nil,
          responses: [String.t()],
          callbacks: map() | nil,
          deprecated?: boolean(),
          security: map(),
          requires_auth?: boolean()
        }

  @spec new(
          operation_id :: String.t(),
          parameters :: [map()],
          request_body :: RequestBody.t() | map(),
          responses :: %{String.t() => any()},
          callbacks :: map() | nil,
          deprecated? :: bool,
          security :: map()
        ) :: t() | {:error, :endpoint_missing_operation_id}
  def new(
        operation_id,
        parameters,
        request_body,
        responses,
        callbacks \\ [],
        deprecated? \\ false,
        security \\ %{}
      )

  # The library relies on an `operation_id` to generate a name to tie the HTTP request to. If one isn't provided, we'll discard it and issue a warning to the caller.
  def new(operation_id, _a, _b, _c, _d, _e, _f) when is_nil(operation_id) do
    {:error, :endpoint_missing_operation_id}
  end

  # a RequestBody `request_body`
  def new(
        operation_id,
        parameters,
        %RequestBody{} = request_body,
        responses,
        callbacks,
        deprecated?,
        security
      )
      when is_binary(operation_id) and is_list(parameters) and is_map(responses) and
             is_map(callbacks) and is_boolean(deprecated?) and is_map(security) do
    %__MODULE__{
      operation_id: operation_id,
      parameters: parameters,
      request_body: request_body,
      responses: Map.keys(responses),
      callbacks: callbacks,
      deprecated?: deprecated?,
      security: security,
      requires_auth?: requires_auth?(security)
    }
  end

  # This has a map `request_body`
  def new(operation_id, parameters, request_body, responses, callbacks, deprecated?, security)
      when is_binary(operation_id) and is_maybe_list(parameters) and is_maybe_map(request_body) and
             is_map(responses) and is_maybe_map(callbacks) and is_maybe_boolean(deprecated?) and
             is_maybe_map(security) do
    %__MODULE__{
      operation_id: operation_id,
      parameters: parameters || [],
      request_body: RequestBody.from_map(request_body),
      responses: Map.keys(responses),
      callbacks: callbacks,
      deprecated?: deprecated?,
      security: security || %{},
      requires_auth?: requires_auth?(security)
    }
  end

  @doc """
  Helper method to determine if the endpoint requires authentication or not
  """
  @spec requires_auth?(security :: map()) :: boolean()
  def requires_auth?(nil), do: false
  def requires_auth?(security) when is_map(security), do: Map.equal?(%{}, security)

  @doc """
  Turns a json map into an `t:Operation.t()/0`
  """
  @spec from_map(json_map :: %{String.t() => any()}) :: t() | nil
  def from_map(nil), do: nil
  # TODO(ian): Do we want to do anything with this? Seems to be caused by callbacks. 
  def from_map(%{"operationId" => nil}), do: nil

  def from_map(json_map) when is_map(json_map) do
    if is_nil(json_map["operationId"]) or not Map.has_key?(json_map, "operationId") do
      nil
    else
      new(
        json_map["operationId"] |> String.replace("-", "_"),
        json_map["parameters"],
        json_map["requestBody"],
        json_map["responses"],
        json_map["callbacks"],
        json_map["deprecated"],
        json_map["security"]
      )
    end
  end
end

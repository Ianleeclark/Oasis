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
    :deprecated,
    :security,
    :requires_auth?
  ]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          operation_id: String.t(),
          parameters: map(),
          request_body: Reference.t() | RequestBody.t() | nil,
          responses: [pos_integer()],
          callbacks: [any()],
          deprecated: boolean(),
          security: map(),
          requires_auth?: boolean()
        }

  @spec new(
          operation_id :: String.t(),
          parameters :: map(),
          request_body :: RequestBody.t() | map(),
          responses :: %{String.t() => any()},
          callbacks :: [any()],
          deprecated :: bool,
          security :: map()
        ) :: t()

  # a RequestBody `request_body`
  def new(
        operation_id,
        parameters,
        %RequestBody{} = request_body,
        responses,
        callbacks,
        deprecated,
        security
      )
      when is_binary(operation_id) and is_map(parameters) and is_map(responses) and
             is_list(callbacks) and is_boolean(deprecated) and is_map(security) do
    %__MODULE__{
      operation_id: operation_id,
      parameters: parameters,
      request_body: request_body,
      responses: Map.keys(responses),
      callbacks: callbacks,
      deprecated: deprecated,
      security: security,
      requires_auth?: requires_auth?(security)
    }
  end

  # This has a map `request_body`
  def new(operation_id, parameters, request_body, responses, callbacks, deprecated, security)
      when is_binary(operation_id) and is_map(parameters) and is_maybe_map(request_body) and
             is_map(responses) and is_list(callbacks) and is_boolean(deprecated) and
             is_map(security) do
    %__MODULE__{
      operation_id: operation_id,
      parameters: parameters,
      request_body: RequestBody.from_map(request_body),
      responses: Map.keys(responses),
      callbacks: callbacks,
      deprecated: deprecated,
      security: security,
      requires_auth?: requires_auth?(security)
    }
  end

  @doc """
  Helper method to determine if the endpoint requires authentication or not
  """
  @spec requires_auth?(security :: map()) :: boolean()
  def requires_auth?(security) when is_map(security), do: Map.equal?(%{}, security)

  @doc """
  Turns a json map into an `t:Operation.t()/0`
  """
  @spec from_map(json_map :: %{String.t() => any()}) :: t() | nil
  def from_map(nil), do: nil

  def from_map(json_map) when is_map(json_map) do
    new(
      json_map["operationId"],
      json_map["parameters"],
      json_map["requestBody"],
      json_map["responses"],
      json_map["callbacks"],
      json_map["deprecated"],
      json_map["security"]
    )
  end
end

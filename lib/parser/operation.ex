defmodule Oasis.Parser.Operation do
  @moduledoc """
  Represents an Operation from OAS 3.0

  See also: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#operationObject
  """

  import Oasis.Utils.Guards

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
          request_body: map() | nil,
          responses: [integer()],
          callbacks: [any()],
          deprecated: boolean(),
          security: map(),
          requires_auth?: boolean()
        }

  def new(operation_id, parameters, request_body, responses, callbacks, deprecated, security)
      when is_binary(operation_id) and is_map(parameters) and is_maybe_map(request_body) and
             is_map(responses) and is_list(callbacks) and is_boolean(deprecated) and
             is_map(security) do
    %__MODULE__{
      operation_id: operation_id,
      parameters: parameters,
      request_body: request_body,
      responses: Enum.map(Map.keys(responses), &String.to_integer/1),
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

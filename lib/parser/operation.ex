defmodule Oasis.Parser.Operation do
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
          parameters: [map()],
          request_body: map(),
          responses: [integer()],
          callbacks: [any()],
          deprecated: boolean(),
          security: map(),
          requires_auth?: boolean()
        }

  def new(operation_id, parameters, request_body, responses, callbacks, deprecated, security)
      when is_binary(operation_id) and is_list(parameters) and is_map(request_body) and
             is_list(responses) and is_list(callbacks) and is_boolean(deprecated) and
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

  @spec requires_auth?(security :: map()) :: boolean()
  def requires_auth?(security) when is_map(security), do: Map.equal?(%{}, security)
end

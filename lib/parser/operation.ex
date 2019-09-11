defmodule Oasis.Parser.Operation do
  @required_keys [:operation_id, :parameters, :request_body, :responses, :callbacks, :deprecated, :security]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
    operation_id: String.t(),
    parameters: [map()],
    request_body: map(),
    responses: [map()],
    callbacks: [any()],
    deprecated: boolean(),
    security: map()
  }

  def new(operation_id, parameters, request_body, responses, callbacks, deprecated, security) when is_binary(operation_id) and is_list(parameters) and is_map(request_body) and is_list(responses) and is_list(callbacks) and is_boolean(deprecated) and is_map(security) do
    %__MODULE__{
      operation_id: operation_id,
      parameters: parameters,
      request_body: request_body,
      responses: responses,
      callbacks: callbacks,
      deprecated: deprecated,
      security: security
    }
  end
end

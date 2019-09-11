defmodule Oasis.Parser.Path do
  alias Oasis.Parser.Operation

  @required_keys [:get, :put, :post, :delete, :patch, :head, :options, :trace, :parameters]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
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
        get \\ nil,
        put \\ nil,
        post \\ nil,
        delete \\ nil,
        patch \\ nil,
        head \\ nil,
        options \\ nil,
        trace \\ nil,
        parameters \\ []
      ) do
    %__MODULE__{
      get: get,
      put: put,
      post: post,
      delete: delete,
      patch: patch,
      head: head,
      options: options,
      trace: trace,
      parameters: parameters
    }
  end

  def from_json(json) do
    new(
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

  def all_http_methods, do: [:get, :put, :post, :delete, :patch, :head, :options, :trace]
end

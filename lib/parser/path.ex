defmodule Oasis.Parser.Path do

  alias Oasis.Parser.Operation

  @required_keys [:get, :put, :post, :delete, :patch, :head, :options, :trace, parameters]
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

  def new(get \\ nil, put \\ nil, post \\ nil, delete \\ nil, patch \\ nil, head \\ nil, options \\ nil, trace \\ nil) do
    %__MODULE__{
      get: get,
      put: put,
      post: post,
      delete: delete,
      patch: patch,
      head: head,
      options: options,
      trace: trace
    }
  end
end

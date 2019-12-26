defmodule Oasis.Parser.Metadata do
  @moduledoc false

  @required_keys [:schema, :requires_auth, :response_status_codes, :uri_params, :uri, :method]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type http_method ::
          :post | :get | :delete | :head | :put | :connect | :options | :trace | :patch

  @type t :: %__MODULE__{
          schema: any(),
          requires_auth: bool(),
          response_status_codes: [integer()],
          uri_params: %{String.t() => String.t() | number()},
          uri: String.t(),
          method: http_method()
        }

  def new(schema, requires_auth, response_status_codes, uri_params, uri, method)
      when is_boolean(requires_auth) and is_list(response_status_codes) and is_binary(uri) and
             is_atom(method) do
    %__MODULE__{
      schema: schema,
      requires_auth: requires_auth,
      response_status_codes: response_status_codes,
      uri_params: uri_params,
      uri: uri,
      method: method
    }
  end
end

defmodule Oasis.Parser.Metadata do
  @required_keys [:schema, :requires_auth, :response_status_codes, :uri_params, :path, :method]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type http_method ::
          :post | :get | :delete | :head | :put | :connect | :options | :trace | :patch

  @type t :: %__MODULE__{
          schema: any(),
          requires_auth: bool(),
          response_status_codes: [integer()],
          uri_params: %{String.t() => String.t() | number()},
          path: String.t(),
          method: http_method()
        }

  def new(schema, requires_auth, response_status_codes, uri_params, path, method)
      when is_boolean(requires_auth) and is_list(response_status_codes) and is_binary(path) and
             is_binary(method) do
    %__MODULE__{
      schema: schema,
      requires_auth: requires_auth,
      response_status_codes: response_status_codes,
      uri_params: uri_params,
      path: path,
      method: method
    }
  end

  @spec http_method_string_to_atom(String.t()) :: atom()
  def http_method_string_to_atom(http_method) when is_binary(http_method) do
    http_method
    |> String.downcase()
    |> case do
      "post" -> :post
      "get" -> :get
      "delete" -> :delete
      "head" -> :head
      "put" -> :put
      "connect" -> :connect
      "options" -> :options
      "trace" -> :trace
      "patch" -> :patch
    end
  end
end

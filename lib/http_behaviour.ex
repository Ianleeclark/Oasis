defmodule Oasis.HTTPBehaviour do
  @moduledoc """
  This is the contract that any user of Oasis must adhere to.

  The API is based upon HTTPoison, but any other library is usable if you
  write a wrapper capable of adhering to this contract.
  """

  @type http_response :: %{
          body: term(),
          headers: [],
          request: any(),
          request_url: binary(),
          status_code: integer()
        }

  @type http_error :: %{
          reason: any()
        }

  @callback delete(url :: String.t(), headers :: list, opts :: list) ::
              {:ok, http_response()} | {:error, http_error()}

  @callback put(url :: String.t(), body :: String.t(), headers :: list, opts :: list) ::
              {:ok, http_response()} | {:error, http_error()}

  @callback post(url :: String.t(), body :: String.t(), headers :: list, opts :: list) ::
              {:ok, http_response()} | {:error, http_error()}

  @callback patch(url :: String.t(), body :: String.t(), headers :: list, opts :: list) ::
              {:ok, http_response()} | {:error, http_error()}

  @callback get(url :: String.t(), headers :: list, opts :: list) ::
              {:ok, http_response()} | {:error, http_error()}

  @callback head(url :: String.t(), headers :: list(), opts :: list()) ::
              {:ok, http_response()} | {:error, http_error()}

  @callback options(url :: String.t(), headers :: list(), opts :: list()) ::
              {:ok, http_response()} | {:error, http_error()}
end

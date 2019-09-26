defmodule Oasis.Testing.HTTP do
  @moduledoc false

  @behaviour Oasis.HTTPSpec

  def get(url, headers \\ [], opts \\ []) do
    {:ok, {url, headers, opts}}
  end

  def put(url, body \\ "", headers \\ [], opts \\ []) do
    {:ok, {url, body, headers, opts}}
  end

  def post(url, body, headers \\ [], opts \\ []) do
    {:ok, {url, body, headers, opts}}
  end

  def patch(url, body, headers \\ [], opts \\ []) do
    {:ok, {url, body, headers, opts}}
  end

  def delete(url, headers \\ [], opts \\ []) do
    {:ok, {url, headers, opts}}
  end

  def head(url, headers \\ [], opts \\ []) do
    {:ok, {url, headers, opts}}
  end

  def options(url, headers \\ [], opts \\ []) do
    {:ok, {url, headers, opts}}
  end
end

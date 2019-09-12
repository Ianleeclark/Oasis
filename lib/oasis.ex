defmodule Oasis do
  @moduledoc """
  Documentation for Oasis.
  """

  alias Oasis.Parser

  @doc """
  Hello world.

  ## Examples

      iex> Oasis.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Loads a file from the specified location
  """
  @spec load_file(directory :: String.t()) :: binary()
  def load_file(directory) when is_binary(directory) do
  end

  def test(directory) do
    directory
    |> load_file()
    |> Parser.load()
  end
end

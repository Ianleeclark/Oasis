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

  def load(json) do
    Parser.load(json)
  end
end

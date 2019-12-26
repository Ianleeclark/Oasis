defmodule Oasis.Schemas.FieldFactory do
  @moduledoc """
  Creates fields based on provided metadata
  """

  alias Oasis.Parser.Schema

  alias Oasis.Schemas.{
    Array,
    Boolean,
    Integer,
    Number,
    Object,
    String
  }

  @spec create_field(name :: String.t(), Schema.t()) :: any()
  def create_field(name, %Schema{type: :boolean} = schema) do
    Boolean.create_field(name, schema)
  end

  def create_field(name, %Schema{type: :array} = schema) do
    Array.create_field(name, schema)
  end

  def create_field(name, %Schema{type: :integer} = schema) do
    Integer.create_field(name, schema)
  end

  def create_field(name, %Schema{type: :number} = schema) do
    Number.create_field(name, schema)
  end

  def create_field(name, %Schema{type: :object} = schema) do
    Object.create_field(name, schema)
  end

  def create_field(name, %Schema{type: :string} = schema) do
    String.create_field(name, schema)
  end
end

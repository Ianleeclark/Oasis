defmodule Oasis.Schemas.Array do
  @moduledoc false

  alias Oasis.Schemas.FieldBehaviour
  alias Oasis.Parser.Schema
  alias Oasis.Schemas.Utils

  @behaviour FieldBehaviour

  @impl FieldBehaviour
  def create_field(name, schema) when is_binary(name) do
    create_field(String.to_atom(name), schema)
  end

  def create_field(name, %Schema{} = schema) when is_atom(name) do
    Utils.create_field(name, schema)
  end

  @doc """
  Takes a format and tells ecto what the proper type to use is.

  This is just a no-op because arrays depend on what they're an
  array of.
  """
  @impl FieldBehaviour
  @spec use_proper_format(Schema.t()) :: :array
  def use_proper_format(%Schema{}), do: :array
end

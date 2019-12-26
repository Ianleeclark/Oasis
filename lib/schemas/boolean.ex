defmodule Oasis.Schemas.Boolean do
  @moduledoc false

  alias Oasis.Schemas.FieldBehaviour
  alias Oasis.Parser.Schema
  alias Oasis.Schemas.Utils

  @behaviour FieldBehaviour

  @impl FieldBehaviour
  def create_field(name, schema) when is_binary(name) do
    # TODO(ian): Explosions?
    create_field(String.to_atom(name), schema)
  end

  def create_field(name, %Schema{} = schema) when is_atom(name) do
    Utils.create_field(name, schema)
  end

  @doc """
  Takes a format and tells ecto what the proper type to use is.

  This is just a no-op.
  """
  @impl FieldBehaviour
  @spec use_proper_format(Schema.t()) :: :boolean
  def use_proper_format(%Schema{}), do: :boolean
end

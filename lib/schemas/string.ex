defmodule Oasis.Schemas.String do
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
  """
  @impl FieldBehaviour
  @spec use_proper_format(Schema.t()) :: atom()
  def use_proper_format(%Schema{format: nil}), do: :string

  def use_proper_format(%Schema{format: format}) do
    case format do
      # TODO(ian): Do some testing here, not sure if correct call.
      :byte -> :binary
      :binary -> :binary
      :date -> :date
      # TODO(ian): Consider if this is the correct datetime
      :dateTime -> :utc_datetime
      _ -> :string
    end
  end
end

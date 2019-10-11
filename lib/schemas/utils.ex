defmodule Oasis.Schemas.Utils do
  @moduledoc """
  Common functions used by schema fields
  """

  alias Oasis.Parser.Schema
  alias Oasis.Schemas.{Array, Boolean, Integer, Number, Object, String}

  @doc """
  Handles creating fields in a consistent manner.
  """
  @spec create_field(name :: atom(), Schema.t()) :: any()
  def create_field(name, %Schema{default: default} = schema) when is_atom(name) do
    corrected_type = handle_format(schema)

    case default do
      x when not is_nil(x) ->
        quote do
          # TODO(Ian): Add validators
          field(unquote(name), unquote(corrected_type), default: unquote(x))
        end

      nil ->
        quote do
          # TODO(Ian): Add validators
          field(unquote(name), unquote(corrected_type))
        end
    end
  end

  @spec handle_format(Schema.t()) :: atom()
  defp handle_format(%Schema{type: field_type} = schema) when is_atom(field_type) do
    module =
      case field_type do
        :array -> Array
        :boolean -> Boolean
        :integer -> Integer
        :number -> Number
        :object -> Object
        :string -> String
      end

    module.use_proper_format(schema)
  end
end

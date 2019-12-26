defmodule Oasis.Schemas do
  @moduledoc """
  Handles schema generation
  """

  alias Oasis.Parser.{MediaType, Operation, Reference, RequestBody, Schema}
  alias Oasis.Schemas.FieldFactory

  @spec create_ecto_schema(Operation.t()) :: {:ok, any()}
  def create_ecto_schema(%Operation{request_body: nil}), do: {:ok, nil}

  def create_ecto_schema(%Operation{} = operation) do
    # TODO(ian): We can reload these schemas with `Metadata.put_meta/2`
    quote(unquote: true) do
      use Ecto.Schema, as: EctoSchema

      alias Oasis.Parser.Schema

      schema unquote(schema_name(operation)) do
        unquote do
          build_schema_fields(operation)
        end
      end
    end
    |> (&Module.create(module_name(operation), &1, __ENV__)).()
  end

  @spec build_schema_fields(Operation.t()) :: any()
  defp build_schema_fields(%Operation{request_body: nil}) do
  end

  defp build_schema_fields(%Operation{request_body: %Reference{}}) do
  end

  defp build_schema_fields(%Operation{request_body: %RequestBody{content: content} = request_body})
       when is_map(request_body) do
    # TODO(ian): Remove the hard-coded value, but only support json in the future.
    request_media = Map.get(content, "application/json")

    case request_media do
      nil ->
        {:error, :no_json_schema_found}

      %MediaType{schema: %Schema{} = schema} ->
        # TODO(ian): Handle arrays
        # TODO(ian): Handle no properties 
        # TODO(ian): Handle references
        Enum.map(schema.properties, fn {k, %Schema{} = v} ->
          # TODO(ian): Enable multiple content-types
          FieldFactory.create_field(k, v)
        end)
    end
  end

  @doc """
  Returns a name for the operation. Typically just the `operation_id`
  """
  @spec schema_name(Operation.t()) :: String.t()
  def schema_name(%Operation{operation_id: operation_id}) when is_binary(operation_id) do
    operation_id
  end

  @doc """
  Returns a name for the exported module.
  """
  @spec module_name(Operation.t()) :: String.t()
  def module_name(%Operation{operation_id: operation_id}) do
    schema_name =
      operation_id
      |> String.split("_")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join()
      |> String.to_atom()

    Module.concat(Oasis.Schemas, schema_name)
  end
end

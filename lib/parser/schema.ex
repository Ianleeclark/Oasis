defmodule Oasis.Parser.Schema do
  @moduledoc """
  Represents an OAS Schema.t

  See also: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schemaObject
  """

  import Oasis.Utils.Guards
  alias Oasis.Schemas.Repo

  @required_keys [:type]
  @optional_keys [
    :maximum,
    :exclusive_maximum,
    :minimum,
    :exclusive_minimum,
    :max_length,
    :min_length,
    :pattern,
    :max_items,
    :min_items,
    :unique_items?,
    :max_properties,
    :min_properties,
    :required?,
    :enum,
    :type,
    :all_of,
    :one_of,
    :any_of,
    :not,
    :items,
    :properties,
    :additional_properties,
    :format,
    :default,
    :nullable?
  ]
  @enforce_keys @required_keys
  defstruct @required_keys ++ @optional_keys

  @type t :: %__MODULE__{
          maximum: number() | nil,
          exclusive_maximum: number() | nil,
          minimum: number() | nil,
          exclusive_minimum: number() | nil,
          max_length: pos_integer() | nil,
          min_length: pos_integer() | nil,
          pattern: String.t(),
          max_items: pos_integer() | nil,
          min_items: pos_integer() | nil,
          unique_items?: boolean(),
          max_properties: pos_integer() | nil,
          min_properties: pos_integer() | nil,
          required?: boolean(),
          enum: [atom()] | nil,
          type: atom(),
          all_of: [t()] | nil,
          one_of: t() | nil,
          any_of: [t()] | nil,
          not: t() | nil,
          items: map() | nil,
          properties: %{String.t() => t()} | nil,
          additional_properties: boolean() | map() | nil,
          format: atom() | nil,
          default: any() | nil,
          nullable?: boolean()
        }

  @spec new(
          type :: atom(),
          required? :: boolean(),
          nullable? :: boolean(),
          maximum :: number() | nil,
          exclusive_maximum :: number() | nil,
          minimum :: number() | nil,
          exclusive_minimum :: number() | nil,
          max_length :: pos_integer() | nil,
          min_length :: pos_integer() | nil,
          pattern :: String.t(),
          max_items :: pos_integer() | nil,
          min_items :: pos_integer() | nil,
          unique_items? :: boolean(),
          max_properties :: pos_integer() | nil,
          min_properties :: pos_integer() | nil,
          enum :: [atom()] | nil,
          all_of :: [t()] | nil,
          one_of :: t() | nil,
          any_of :: [t()] | nil,
          is_not :: t() | nil,
          items :: map() | nil,
          properties :: %{String.t() => t()} | nil,
          additional_properties :: boolean() | map() | nil,
          format :: atom() | nil,
          default :: any() | nil
        ) :: t()
  # credo:disable-for-next-line
  def new(
        type,
        format \\ nil,
        maximum \\ nil,
        exclusive_maximum \\ nil,
        minimum \\ nil,
        exclusive_minimum \\ nil,
        max_length \\ nil,
        min_length \\ nil,
        pattern \\ nil,
        max_items \\ nil,
        min_items \\ nil,
        unique_items? \\ false,
        max_properties \\ nil,
        min_properties \\ nil,
        required? \\ false,
        enum \\ nil,
        all_of \\ nil,
        one_of \\ nil,
        any_of \\ nil,
        is_not \\ nil,
        items \\ nil,
        properties \\ nil,
        additional_properties \\ nil,
        default \\ nil,
        nullable? \\ false
      )
      when is_atom(type) and is_atom(format) and is_maybe_number(maximum) and
             is_maybe_number(minimum) and is_maybe_number(exclusive_maximum) and
             is_maybe_number(exclusive_minimum) and is_maybe_pos_integer(min_length) and
             is_maybe_pos_integer(max_length) and is_maybe_pos_integer(max_items) and
             is_maybe_pos_integer(min_items) and is_maybe_boolean(unique_items?) and
             is_maybe_boolean(required?) and is_maybe_list(enum) and is_maybe_boolean(nullable?) and
             is_maybe_map(properties) do
    props =
      case type do
        :object ->
          properties
          |> Enum.into(%{}, fn {name, prop} -> {name, from_map(prop)} end)

        _ ->
          properties
      end

    %__MODULE__{
      maximum: maximum,
      exclusive_maximum: exclusive_maximum,
      minimum: minimum,
      exclusive_minimum: exclusive_minimum,
      max_length: max_length,
      min_length: min_length,
      pattern: pattern,
      max_items: max_items,
      min_items: min_items,
      unique_items?: unique_items?,
      max_properties: max_properties,
      min_properties: min_properties,
      required?: required?,
      enum: enum,
      type: type,
      all_of: all_of,
      one_of: one_of,
      any_of: any_of,
      not: is_not,
      items: items,
      properties: props,
      additional_properties: additional_properties,
      format: format,
      default: default,
      nullable?: nullable?
    }
  end

  @doc """
  Converts a json map into a `Schema.t()` 
  """
  @spec from_map(map()) :: t()
  def from_map(%{"schema" => schema}) when is_map(schema) do
    from_map(schema)
  end

  def from_map(schema) when is_map(schema) do
    required_keys =
      case Map.get(schema, "required", []) do
        x when is_list(x) ->
          x

        _ ->
          []
      end

    properties = Map.get(schema, "properties", %{})
    required_properties = inject_required_keys(properties, required_keys)
    updated_schema = Map.put(schema, "properties", required_properties)

    cond do
      schema["$ref"] != nil ->
        schema["$ref"]
        |> parse_schema_name()
        |> Repo.fetch_schema_by_name()
        |> case do
          {:ok, schema} ->
            schema

          _other ->
            from_map(schema)
        end

      Map.has_key?(updated_schema, "type") ->
        case updated_schema["type"] |> type_from_string() do
          {:error, :invalid_type} ->
            # TODO(ian): ARRAY ARRAY ARRAY (most likely)
            new(:empty)

          _ ->
            new(
              updated_schema["type"] |> type_from_string(),
              Map.get(updated_schema, "format") |> format_from_string(),
              Map.get(updated_schema, "maximum"),
              Map.get(updated_schema, "exclusiveMaximum"),
              Map.get(updated_schema, "minimum"),
              Map.get(updated_schema, "exclusiveMinimum"),
              Map.get(updated_schema, "maxLength"),
              Map.get(updated_schema, "minLength"),
              Map.get(updated_schema, "pattern"),
              Map.get(updated_schema, "maxItems"),
              Map.get(updated_schema, "minItems"),
              Map.get(updated_schema, "uniqueIems"),
              Map.get(updated_schema, "maxProperties"),
              Map.get(updated_schema, "minProperties"),
              # TODO(ian): Ignore this field if there are any `properties`
              not Enum.empty?(required_keys),
              Map.get(updated_schema, "enum"),
              Map.get(updated_schema, "allOf"),
              Map.get(updated_schema, "oneOf"),
              Map.get(updated_schema, "anyOf"),
              Map.get(updated_schema, "isNot"),
              Map.get(updated_schema, "items"),
              required_properties,
              Map.get(updated_schema, "additionalProperties"),
              Map.get(updated_schema, "default"),
              Map.get(updated_schema, "nullable")
            )
        end

      true ->
        new(:empty)
    end
  end

  @doc """
  Lists all keys that can be used to validate incoming data.
  """
  @spec validator_keys() :: [atom()]
  def validator_keys do
    [
      :maximum,
      :exclusive_maximum,
      :exclusive_minimum,
      :minimum,
      :max_length,
      :min_length,
      :pattern,
      :max_items,
      :min_items,
      :unique_items?,
      :required?,
      :enum,
      :not
    ]
  end

  @doc """
  Lists all keys that can be used to inflate/alter the schema
  """
  @spec mutative_keys() :: [atom()]
  def mutative_keys do
    [:all_of, :one_of, :any_of, :not, :items]
  end

  @spec type_from_string(type_string :: String.t()) :: atom() | {:error, :invalid_type}
  defp type_from_string(type_string) when is_binary(type_string) do
    case type_string do
      "integer" ->
        :integer

      "number" ->
        :number

      "string" ->
        :string

      "boolean" ->
        :boolean

      "object" ->
        :object

      _ ->
        {:error, :invalid_type}
    end
  end

  @spec valid_types() :: [atom()]
  def valid_types, do: [:integer, :number, :string, :boolean, :object]

  @spec format_from_string(format_string :: String.t() | nil) ::
          atom() | {:error, :invalid_format}
  defp format_from_string(nil), do: nil

  # credo:disable-for-next-line
  defp format_from_string(format_string) when is_binary(format_string) do
    case format_string do
      "int32" -> :int32
      "int64" -> :int64
      "float" -> :float
      "double" -> :double
      "byte" -> :byte
      "binary" -> :binary
      "date" -> :date
      "date-time" -> :date_time
      "password" -> :password
      _ -> {:error, :invalid_format}
    end
  end

  @spec valid_formats() :: [atom()]
  def valid_formats,
    do: [
      :int32,
      :int64,
      :float,
      :double,
      :byte,
      :binary,
      :date,
      :date_time,
      :password
    ]

  @spec inject_required_keys(properties :: map(), required_keys :: [String.t()]) :: map()
  defp inject_required_keys(properties, required_keys)
       when is_map(properties) and is_list(required_keys) do
    properties
    |> Enum.into(%{}, fn {property, x} = pair when is_map(x) ->
      case Enum.member?(required_keys, property) do
        true ->
          {property, Map.put(x, "required", true)}

        false ->
          pair
      end
    end)
  end

  @spec parse_schema_name(schema_ref :: String.t()) :: String.t()
  def parse_schema_name(schema_ref) when is_binary(schema_ref) do
    schema_ref
    |> String.split("/")
    |> List.last()
  end
end

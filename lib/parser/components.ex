defmodule Oasis.Parser.Components do
  @moduledoc """
  Wraps the `Components` in the top-level object.

  https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#componentsObject
  """
  import Oasis.Utils.Guards
  alias Oasis.Parser.Schema

  @required_keys [:schemas]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          schemas: map() | nil
        }

  @spec new(schemas :: %{String.t() => Schema.t()} | nil) :: t()
  def new(schemas) when is_maybe_map(schemas) do
    %__MODULE__{
      schemas: schemas
    }
  end

  @spec from_map(map :: map()) :: t()
  def from_map(nil), do: new(nil)

  def from_map(map) when is_map(map) do
    map
    |> Map.get("schemas", %{})
    |> Enum.into(%{}, fn {name, schema} ->
      {name, Schema.from_map(schema)}
    end)
    |> new()
  end
end

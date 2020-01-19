defmodule Oasis.Parser.MediaType do
  @moduledoc """
  Represents the internals of a `requestBody`

  See also: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#mediaTypeObject
  """

  alias Oasis.Parser.Schema

  # NOTE: Explicitly ignoring the `example(s)`, as they don't seem practically useful
  @required_keys [:schema, :encoding]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          schema: Schema.t(),
          encoding: String.t()
        }

  @spec new(Schema.t(), String.t()) :: t()
  def new(%Schema{} = schema, encoding) do
    %__MODULE__{schema: schema, encoding: encoding}
  end

  @spec from_map(media :: map()) :: t()
  def from_map(_media, encoding \\ "application/json")
  def from_map(nil, _encoding), do: nil

  def from_map(media, encoding) when is_map(media) do
    new(
      Schema.from_map(media),
      encoding
    )
  end

  def from_map(%Schema{} = media, encoding) do
    new(media, encoding)
  end
end

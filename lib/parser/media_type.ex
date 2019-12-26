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
  def new(schema, encoding) do
    %__MODULE__{schema: schema, encoding: encoding}
  end
end

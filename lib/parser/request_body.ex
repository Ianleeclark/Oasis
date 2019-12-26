defmodule Oasis.Parser.RequestBody do
  @moduledoc """
  Represents what the operation expects.

  See also: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#requestBodyObject
  """

  alias Oasis.Parser.MediaType

  @required_keys [:description, :content, :required?]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          description: String.t() | nil,
          content: %{String.t() => MediaType.t()},
          required?: boolean()
        }

  @spec new(
          description :: String.t() | nil,
          content :: %{String.t() => MediaType.t()},
          required? :: boolean()
        ) :: t()
  def new(description, content, required?) when is_boolean(required?) do
    %__MODULE__{description: description, content: content, required?: required?}
  end
end

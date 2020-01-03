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
  def new(description, content, required?) when is_boolean(required?) and is_map(content) do
    %__MODULE__{description: description, content: content, required?: required?}
  end

  @spec from_map(request_body :: map() | nil) :: t()
  def from_map(nil), do: nil

  def from_map(request_body) when is_map(request_body) do
    content_by_content_type = Map.get(request_body, "content", %{})

    content =
      content_by_content_type
      |> Enum.into(%{}, fn {content_type, body} ->
        {content_type, MediaType.from_map(body)}
      end)

    new(
      Map.get(request_body, "description"),
      content,
      Map.get(request_body, "required", false)
    )
  end
end

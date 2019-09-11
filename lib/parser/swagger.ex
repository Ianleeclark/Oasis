defmodule Oasis.Parser.Swagger do

  alias Oasis.Parser.Path

  @required_keys [:version, :security, :paths, :components]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
    version: String.t(),
    security: map(),
    paths: %{String.t() => Path.t()},
    components: []
  }
end

defmodule Oasis.Parser.Swagger do
  @moduledoc """
  This is a friendly wrapper to OAS data made to allow easier navigation
  of the spec than referencing keys in a map.
  """
  # TODO(ian): Rename Swagger to OAS
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

  def new(version, security, paths, components)
      when is_binary(version) and is_map(security) and is_map(paths) and is_list(components) do
    %__MODULE__{
      version: version,
      security: security,
      paths: paths,
      components: components
    }
  end
end

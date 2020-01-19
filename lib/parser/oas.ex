defmodule Oasis.Parser.OAS do
  @moduledoc """
  This is a friendly wrapper to OAS data made to allow easier navigation
  of the spec than referencing keys in a map.
  """
  import Oasis.Utils.Guards
  alias Oasis.Parser.{Components, Path}

  @required_keys [:version, :security, :paths, :components]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          version: String.t() | nil,
          security: map(),
          paths: %{String.t() => Path.t()},
          components: map() | nil
        }

  @spec new(version :: String.t(), security :: map(), paths :: map(), components :: map()) :: t()
  def new(version, security, paths, components)
      when is_maybe_binary(version) and is_maybe_map(security) and is_map(paths) and
             is_maybe_map(components) do
    safe_security =
      case security do
        nil -> %{}
        _ -> security
      end

    %__MODULE__{
      version: version,
      security: safe_security,
      paths: paths,
      components: Components.from_map(components)
    }
  end
end

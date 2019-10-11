defmodule Oasis.Parser.Reference do
  @moduledoc """
  References another schema
  """

  @required_keys [:ref]
  @enforce_keys @required_keys
  defstruct @required_keys

  @type t :: %__MODULE__{
          ref: String.t()
        }

  @spec new(ref :: String.t()) :: t()
  def new(ref) when is_binary(ref) do
    %__MODULE__{ref: ref}
  end
end

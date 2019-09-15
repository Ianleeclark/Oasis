defmodule Oasis.Guards do
  @moduledoc """
  Houses commonly used guards
  """

  defguard is_maybe_map(maybe_map) when is_nil(maybe_map) or is_map(maybe_map)
end

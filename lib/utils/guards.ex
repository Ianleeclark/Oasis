defmodule Oasis.Utils.Guards do
  @moduledoc """
  Houses commonly used guards
  """

  defguard is_maybe_map(maybe_map) when is_nil(maybe_map) or is_map(maybe_map)

  defguard is_maybe_number(maybe_number) when is_nil(maybe_number) or is_number(maybe_number)

  defguard is_maybe_binary(maybe_binary) when is_nil(maybe_binary) or is_binary(maybe_binary)

  defguard is_maybe_integer(maybe_integer) when is_nil(maybe_integer) or is_integer(maybe_integer)

  defguard is_maybe_boolean(maybe_boolean) when is_nil(maybe_boolean) or is_boolean(maybe_boolean)

  defguard is_maybe_pos_integer(maybe_pos_integer)
           when is_nil(maybe_pos_integer) or
                  (is_integer(maybe_pos_integer) and maybe_pos_integer >= 0)

  defguard is_maybe_list(maybe_list) when is_nil(maybe_list) or is_list(maybe_list)
end

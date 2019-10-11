defmodule Oasis.Schemas.FieldBehaviour do
  @moduledoc """
  Dictates what each field needs to be able to do.
  """

  alias Oasis.Parser.Schema

  @callback use_proper_format(Schema.t()) :: atom()
  @callback create_field(name :: String.t() | atom(), Schema.t()) :: any()
end

defmodule Oasis.Parser.ReferenceTest do
  use ExUnit.Case

  alias Oasis.Parser.Schema

  import ExUnitProperties

  maybe_number = ExUnitProperties.gen_all(StreamData.one_of())

  property "Constructs normally" do
    check all(
            type <- StreamData.one_of(Schema.valid_types()),
            required? StreamData.boolean(),
            nullable? StreamData.boolean(),
            maximum <- maybe_number(),
            exclusive_maximum <- maybe_number(),
            minimum <- maybe_number(),
            exclusive_minimum <- maybe_number(),
            max_length <- maybe_pos_integer(),
            min_length <- maybe_pos_integer(),
            pattern <- StreamData.constant("[a-Z0-9]"),
            max_items <- maybe_pos_integer(),
            min_items <- maybe_pos_integer(),
            unique_items? <- StreamData.boolean(),
      max_properties <- maybe_pos_integer(),
            min_properties <- maybe_pos_integer(),
            enum :: [atom()] | nil,
            all_of :: [t()] | nil,
            one_of :: t() | nil,
            any_of :: [t()] | nil,
            is_not :: t() | nil,
            items :: map() | nil,
            properties :: %{String.t() => t()} | nil,
            additional_properties :: boolean() | map() | nil,
            format <- StreamData.one_of(Schema.valid_formats),
            default :: any() | nil
          ) do
      result = %Schema{} = Reference.new(ref)
    end
  end
end

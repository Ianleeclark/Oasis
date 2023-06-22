defmodule Oasis.Parser.SchemaTest do
  use ExUnit.Case

  alias Oasis.Parser.Schema

  import ExUnitProperties

  def maybe_number() do
    StreamData.constant(:unused)
    |> StreamData.bind(fn _ ->
      StreamData.one_of([StreamData.integer(), StreamData.constant(nil)])
    end)
    |> StreamData.unshrinkable()
  end

  def maybe_pos_integer() do
    StreamData.constant(:unused)
    |> StreamData.bind(fn _ ->
      StreamData.one_of([StreamData.positive_integer(), StreamData.constant(nil)])
    end)
    |> StreamData.unshrinkable()
  end

  property "Constructs normally" do
    check all(
            type <- StreamData.one_of(Schema.valid_types()),
            required? <- StreamData.boolean(),
            nullable? <- StreamData.boolean(),
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
            enum <- StreamData.constant(nil),
            all_of <- StreamData.constant(nil),
            one_of <- StreamData.constant(nil),
            any_of <- StreamData.constant(nil),
            is_not <- StreamData.constant(nil),
            items <- StreamData.constant(nil),
            properties <- StreamData.constant(nil),
            additional_properties <- StreamData.constant(nil),
            format <- StreamData.one_of(Schema.valid_formats()),
            default <- StreamData.constant(nil)
          ) do
      result =
        %Schema{} =
        Schema.new(
          type,
          format,
          maximum,
          exclusive_maximum,
          minimum,
          exclusive_minimum,
          max_length,
          min_length,
          pattern,
          max_items,
          min_items,
          unique_items?,
          max_properties,
          min_properties,
          required?,
          enum,
          all_of,
          one_of,
          any_of,
          is_not,
          items,
          properties,
          additional_properties,
          default,
          nullable?
        )
    end
  end
end

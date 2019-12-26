defmodule Oasis.Parser.NumberTest do
  use ExUnit.Case

  alias Oasis.Parser.Schema
  alias Oasis.Schemas.Number

  setup_all do
    schema = Schema.new(:number)

    %{schema: schema}
  end

  describe "create_field/2" do
    test "bare-minimum boolean", %{schema: schema} do
      retval = Number.create_field("foobar", schema)
      assert retval == {:field, [], [:foobar, :number]}
    end

    test "boolean w/ default", %{schema: schema} do
      updated_schema = %Schema{schema | default: 5.0}
      retval = Number.create_field("foobar", updated_schema)
      assert retval == {:field, [], [:foobar, :number, [default: 5.0]]}
    end
  end

  describe "use_proper_format/1" do
    test "Default value still works", %{schema: schema} do
      retval = Number.create_field("foobar", schema)
      assert retval == {:field, [], [:foobar, :number]}
    end

    test "Verify format handled for float", %{schema: schema} do
      modified_schema = %Schema{schema | format: :float}
      retval = Number.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :float]}
    end

    test "Verify format handled for int64", %{schema: schema} do
      modified_schema = %Schema{schema | format: :decimal}
      retval = Number.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :decimal]}
    end
  end
end

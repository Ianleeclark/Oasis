defmodule Oasis.Parser.IntegerTest do
  use ExUnit.Case

  alias Oasis.Parser.Schema
  alias Oasis.Schemas.Integer

  setup_all do
    schema = Schema.new(:integer)

    %{schema: schema}
  end

  describe "create_field/2" do
    test "bare-minimum boolean", %{schema: schema} do
      retval = Integer.create_field("foobar", schema)
      assert retval == {:field, [], [:foobar, :integer]}
    end

    test "boolean w/ default", %{schema: schema} do
      updated_schema = %Schema{schema | default: 5}
      retval = Integer.create_field("foobar", updated_schema)
      assert retval == {:field, [], [:foobar, :integer, [default: 5]]}
    end
  end

  describe "use_proper_format/1" do
    test "Default value still works", %{schema: schema} do
      retval = Integer.create_field("foobar", schema)
      assert retval == {:field, [], [:foobar, :integer]}
    end

    test "Verify format handled for int32", %{schema: schema} do
      modified_schema = %Schema{schema | format: :int32}
      retval = Integer.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :integer]}
    end

    test "Verify format handled for int64", %{schema: schema} do
      modified_schema = %Schema{schema | format: :int64}
      retval = Integer.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :integer]}
    end
  end
end

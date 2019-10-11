defmodule Oasis.Parser.BooleanTest do
  use ExUnit.Case

  alias Oasis.Parser.Schema
  alias Oasis.Schemas.Boolean

  setup_all do
    schema = Schema.new(:boolean)

    %{schema: schema}
  end

  describe "create_field/2" do
    test "bare-minimum boolean", %{schema: schema} do
      retval = Boolean.create_field("foobar", schema)
      assert retval == {:field, [], [:foobar, :boolean]}
    end

    test "boolean w/ default", %{schema: schema} do
      true_schema = %Schema{schema | default: true}
      true_retval = Boolean.create_field("foobar", true_schema)
      assert true_retval == {:field, [], [:foobar, :boolean, [default: true]]}

      false_schema = %Schema{schema | default: false}
      false_retval = Boolean.create_field("foobar", false_schema)
      assert false_retval == {:field, [], [:foobar, :boolean, [default: false]]}
    end
  end

  describe "use_proper_format/1" do
    test "Verify no-op", %{schema: schema} do
      modified_schema = %Schema{schema | format: :int32}
      retval = Boolean.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :boolean]}
    end
  end
end

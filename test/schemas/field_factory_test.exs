defmodule Oasis.Parser.FieldFactoryTest do
  use ExUnit.Case

  alias Oasis.Parser.Schema
  alias Oasis.Schemas.FieldFactory

  setup_all do
    bool_schema = Schema.new(:boolean)
    integer_schema = Schema.new(:integer)
    number_schema = Schema.new(:number)
    string_schema = Schema.new(:string)

    %{
      bool_schema: bool_schema,
      integer_schema: integer_schema,
      number_schema: number_schema,
      string_schema: string_schema
    }
  end

  describe "create_field/2 w/o defaults" do
    test "Boolean", %{bool_schema: schema} do
      retval = FieldFactory.create_field("test", schema)
      assert retval == {:field, [], [:test, :boolean]}
    end

    test "Integer", %{integer_schema: schema} do
      retval = FieldFactory.create_field("test", schema)
      assert retval == {:field, [], [:test, :integer]}
    end

    test "Number", %{number_schema: schema} do
      retval = FieldFactory.create_field("test", schema)
      assert retval == {:field, [], [:test, :number]}
    end

    test "String", %{string_schema: schema} do
      retval = FieldFactory.create_field("test", schema)
      assert retval == {:field, [], [:test, :string]}
    end
  end
end

defmodule Oasis.Parser.StringTest do
  use ExUnit.Case

  alias Oasis.Parser.Schema
  alias Oasis.Schemas.String

  setup_all do
    schema = Schema.new(:string)

    %{schema: schema}
  end

  describe "create_field/2" do
    test "bare-minimum boolean", %{schema: schema} do
      retval = String.create_field("foobar", schema)
      assert retval == {:field, [], [:foobar, :string]}
    end

    test "boolean w/ default", %{schema: schema} do
      updated_schema = %Schema{schema | default: "bax"}
      retval = String.create_field("foobar", updated_schema)
      assert retval == {:field, [], [:foobar, :string, [default: "bax"]]}
    end
  end

  describe "use_proper_format/1" do
    test "Default value still works", %{schema: schema} do
      retval = String.create_field("foobar", schema)
      assert retval == {:field, [], [:foobar, :string]}
    end

    test "Verify blank format is :string", %{schema: schema} do
      modified_schema = %Schema{schema | format: nil}
      retval = String.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :string]}
    end

    test "Verify format handled for byte", %{schema: schema} do
      modified_schema = %Schema{schema | format: :byte}
      retval = String.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :binary]}
    end

    test "Verify format handled for binary", %{schema: schema} do
      modified_schema = %Schema{schema | format: :binary}
      retval = String.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :binary]}
    end

    test "Verify format handled for date", %{schema: schema} do
      modified_schema = %Schema{schema | format: :date}
      retval = String.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :date]}
    end

    test "Verify format handled for dateTime", %{schema: schema} do
      modified_schema = %Schema{schema | format: :dateTime}
      retval = String.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :utc_datetime]}
    end

    test "Verify format handled for password", %{schema: schema} do
      modified_schema = %Schema{schema | format: :password}
      retval = String.create_field("foobar", modified_schema)
      assert retval == {:field, [], [:foobar, :string]}
    end
  end
end

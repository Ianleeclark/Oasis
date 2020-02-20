defmodule Oasis.SchemasTest do
  use ExUnit.Case

  alias Oasis.Parser.{Schema, RequestBody, MediaType, Operation}
  alias Oasis.Schemas

  setup_all do
    schema = %Schema{
      type: :object,
      properties: %{
        "test_field" => %Schema{type: :boolean},
        "string_field" => %Schema{type: :string, format: :date},
        "object_field" => %Schema{type: :object, properties: []}
      }
    }

    media_type = MediaType.new(schema, "encoding")

    request_body = RequestBody.new("Foobar", %{"application/json" => media_type}, false)

    operation =
      Operation.new(
        "test_operation_id",
        [%{foo: "bar"}],
        request_body,
        %{"200" => %{}, "404" => %{}, "default" => %{}},
        %{},
        true,
        %{}
      )

    %{schema: schema, operation: operation}
  end

  describe "schema_name/1" do
    test "Ensure returns the operation ID", %{operation: operation} do
      assert Schemas.schema_name(operation) == "test_operation_id"
    end
  end

  describe "module_name/1" do
    test "Ensure returns the operation ID", %{operation: operation} do
      assert Schemas.module_name(operation) == Oasis.Schemas.TestOperationId
    end
  end

  describe "create_ecto_schema/1" do
    test "Exports a usable schema as a module", %{operation: operation} do
      Schemas.create_ecto_schema(operation)

      assert Enum.member?(Oasis.Schemas.TestOperationId.__schema__(:fields), :test_field)
      assert Enum.member?(Oasis.Schemas.TestOperationId.__schema__(:fields), :string_field)
      assert Oasis.Schemas.TestOperationId.__schema__(:type, :test_field) == :boolean
      assert Oasis.Schemas.TestOperationId.__schema__(:type, :string_field) == :date
    end
  end
end

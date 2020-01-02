defmodule Oasis.Parser.PathTest do
  use ExUnit.Case

  alias Oasis.Parser.{Path, RequestBody}

  @operation_values %{
    "operationId" => "test_operation_id",
    "parameters" => %{},
    "requestBody" => %{},
    "responses" => %{},
    "callbacks" => [],
    "deprecated" => false,
    "security" => %{}
  }

  describe "new/10" do
    test "Can create with default values" do
      path = Path.new("/v1/users")

      assert path.uri == "/v1/users"
    end

    test "Can create with semi-real values" do
      path =
        Path.from_map(
          "/v1/users",
          %{
            "get" => @operation_values,
            "put" => @operation_values,
            "post" => @operation_values,
            "delete" => @operation_values,
            "patch" => @operation_values,
            "parameters" => ["asdf"]
          }
        )

      assert path.uri == "/v1/users"
      assert path.parameters == ["asdf"]

      assert is_nil(path.head)
      assert is_nil(path.options)
      assert is_nil(path.trace)

      [path.get, path.put, path.post, path.delete, path.patch]
      |> Enum.map(fn x ->
        refute is_nil(x)

        assert x.operation_id == "test_operation_id"
        assert x.parameters == %{}
        assert x.request_body == %RequestBody{content: %{}, description: nil, required?: false}
        assert x.responses == []
        assert x.callbacks == []
        assert x.deprecated == false
        assert x.security == %{}
      end)
    end
  end

  describe "all_http_methods/0" do
    test "make sure all expected methods are present" do
      expected = [:get, :put, :post, :delete, :patch, :head, :options, :trace]

      returned = Path.all_http_methods()

      Enum.map(expected, fn expected ->
        assert Enum.member?(returned, expected)
      end)
    end
  end
end

defmodule Oasis.ParserTest do
  use ExUnit.Case
  alias Oasis.Parser
  alias Oasis.Parser.{OAS, Path}

  doctest Parser

  @test_spec %{
    "paths" => %{
      "/payments/subscriptions" => %{
        "post" => %{
          "operationId" => "subscriptions_post",
          "parameters" => %{},
          "requestBody" => %{"$ref" => "#!/components/schemas/NewSubscription"},
          "responses" => %{
            "200" => %{},
            "400" => %{}
          },
          "callbacks" => [],
          "deprecated" => true,
          "security" => %{}
        },
        "put" => %{
          "operationId" => "subscriptions_put",
          "parameters" => %{},
          "requestBody" => nil,
          "responses" => %{
            "200" => %{},
            "400" => %{}
          },
          "callbacks" => [],
          "deprecated" => true,
          "security" => %{}
        },
        "delete" => %{
          "operationId" => "subscriptions_delete",
          "parameters" => %{},
          "requestBody" => nil,
          "responses" => %{
            "200" => %{},
            "400" => %{}
          },
          "callbacks" => [],
          "deprecated" => true,
          "security" => %{}
        }
      },
      "/users" => %{
        "post" => %{
          "operationId" => "users_post",
          "parameters" => %{},
          "requestBody" => %{"$ref" => "#!/components/schemas/NewUser"},
          "responses" => %{
            "200" => %{},
            "400" => %{}
          },
          "callbacks" => [],
          "deprecated" => true,
          "security" => %{}
        },
        "put" => %{
          "operationId" => "users_put",
          "parameters" => %{},
          "requestBody" => nil,
          "responses" => %{
            "200" => %{},
            "400" => %{}
          },
          "callbacks" => [],
          "deprecated" => true,
          "security" => %{}
        },
        "delete" => %{
          "operationId" => "users_delete",
          "parameters" => %{},
          "requestBody" => nil,
          "responses" => %{
            "200" => %{},
            "400" => %{}
          },
          "callbacks" => [],
          "deprecated" => true,
          "security" => %{}
        }
      }
    },
    "security" => %{},
    "components" => %{"schemas" => %{"NewSubscription" => %{}, "NewUser" => %{}}},
    "version" => "3.0.0"
  }

  describe "load_json/1" do
    test "Loads valid json" do
      json = "{\"foo\": \"bar\"}"
      {:ok, loaded_json} = Parser.load_json(json)

      assert Map.get(loaded_json, "foo") == "bar"
    end

    test "Fails to load invalid json" do
      json = "foobar"
      assert {:error, :invalid_json} == Parser.load_json(json)
    end
  end

  describe "map_json_to_oas_struct/1" do
    test "Fails due to no OAS `paths` key" do
      json_map = %{"components" => %{}, "security" => []}
      retval = Parser.map_json_to_oas_struct(json_map)

      assert retval == {:error, :invalid_api_spec}
    end

    test "Loads an `OAS` struct properly" do
      {:ok, retval} = Parser.map_json_to_oas_struct(@test_spec)

      assert retval.version == "3.0.0"
      assert is_map(retval.security)
      assert is_map(retval.components)

      subscription_paths = retval.paths["/payments/subscriptions"]
      user_paths = retval.paths["/users"]

      [:post, :put, :delete]
      |> Enum.map(fn method ->
        assert is_map(Map.get(user_paths, method))
        assert is_map(Map.get(subscription_paths, method))
      end)
    end
  end

  describe "extract_metadata_from_operations/1" do
    test "Loads metadata" do
      {:ok, %OAS{} = retval} = Parser.map_json_to_oas_struct(@test_spec)
      {:ok, metadata} = Parser.extract_metadata_from_operations(retval)

      expected_keys = [
        "subscriptions_post",
        "subscriptions_put",
        "subscriptions_delete",
        "users_post",
        "users_put",
        "users_delete"
      ]

      Enum.map(expected_keys, fn expected_key ->
        assert Map.has_key?(metadata, expected_key)
      end)
    end
  end
end

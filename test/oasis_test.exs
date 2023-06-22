defmodule OasisTest do
  use ExUnit.Case
  doctest Oasis

  @moduletag timeout: 1_000

  describe "register_endpoints_from_filename/1" do
    test "Ensure can parse OAS-provided examples." do
      Path.absname("./test/data")
      |> Path.join("*.json")
      |> Path.wildcard()
      |> Enum.map(&Oasis.register_endpoints_from_filename/1)
    end
  end

  describe "loads correct operation endpoints from test data" do
    test "uspto.json" do
      Oasis.register_endpoints_from_filename("./test/data/uspto.json")

      expected_functions = [
        {:list_data_sets, 3},
        {:list_searchable_fields, 3},
        {:perform_search, 3}
      ]

      expected_functions
      |> Enum.map(fn {fn_name, arity} ->
        assert Kernel.function_exported?(Oasis.Endpoints, fn_name, arity)
      end)
    end
  end
end

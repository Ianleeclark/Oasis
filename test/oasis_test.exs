defmodule OasisTest do
  use ExUnit.Case
  doctest Oasis

  describe "register_endpoints_from_filename/1" do
    test "Ensure can parse OAS-provided examples." do
      Path.absname("./test/data")
      |> Path.join("*.json")
      |> Path.wildcard()
      |> Enum.map(fn file_name ->
        IO.inspect(file_name)
        Oasis.register_endpoints_from_filename(file_name)
      end)
    end
  end
end

defmodule Oasis.Parser.ComponentsTest do
  use ExUnit.Case

  alias Oasis.Parser.Components

  describe "new/1" do
    test "Non-nil value" do
      retval = Components.new(%{foo: "bar"})

      assert Map.get(retval.schemas, :foo) == "bar"
    end

    test "Nil value" do
      retval = Components.new(nil)

      assert retval.schemas == nil
    end
  end

  describe "from_map/1" do
    test "Non-nil value" do
      retval = Components.from_map(%{"schemas" => %{foo: "bar"}})

      assert Map.get(retval.schemas, :foo) == "bar"
    end

    test "Nil value" do
      retval = Components.new(nil)

      assert retval.schemas == nil
    end
  end

  import ExUnitProperties

  property "Constructs normally" do
    check all(schemas <- StreamData.map_of(StreamData.string(:ascii), StreamData.integer())) do
      components = Components.new(schemas)

      assert components.schemas == schemas
    end
  end
end

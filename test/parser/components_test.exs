defmodule Oasis.Parser.ComponentsTest do
  use ExUnit.Case

  alias Oasis.Parser.Components
  alias Oasis.Parser.Schema

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
      retval = Components.from_map(%{"schemas" => %{foo: %{}}})

      assert Map.get(retval.schemas, :foo) == Schema.new(:empty)
    end

    test "Nil value" do
      retval = Components.new(nil)

      assert retval.schemas == nil
    end
  end
end

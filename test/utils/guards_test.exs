defmodule Oasis.GuardsTest do
  use ExUnit.Case
  doctest Oasis.Utils.Guards

  import Oasis.Utils.Guards

  describe "is_maybe_map/1" do
    test "Non-nil map" do
      assert is_maybe_map(%{})
    end

    test "Nil value" do
      assert is_maybe_map(nil)
    end
  end
end

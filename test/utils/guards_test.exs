defmodule Oasis.GuardsTest do
  use ExUnit.Case
  doctest Oasis.Utils.Guards

  import Oasis.Utils.Guards

  describe "is_maybe_map/1" do
    test "Non-nil" do
      assert is_maybe_map(%{})
      assert is_maybe_map(%{"foo" => "bar"})
    end

    test "Nil value" do
      assert is_maybe_map(nil)
    end
  end

  describe "is_maybe_number/1" do
    test "Non-nil" do
      assert is_maybe_number(5)
      assert is_maybe_number(-5)
      assert is_maybe_number(5.0)
      assert is_maybe_number(0.0)
      assert is_maybe_number(0)
    end

    test "Nil value" do
      assert is_maybe_binary(nil)
    end
  end

  describe "is_maybe_binary/1" do
    test "Non-nil" do
      assert is_maybe_binary("")
      assert is_maybe_binary("foobar")
    end

    test "Nil value" do
      assert is_maybe_binary(nil)
    end
  end

  describe "is_maybe_integer/1" do
    test "Non-nil" do
      assert is_maybe_integer(5)
      assert is_maybe_integer(-5)
      refute is_maybe_integer(5.0)
    end

    test "Nil value" do
      assert is_maybe_integer(nil)
    end
  end

  describe "is_maybe_boolean/1" do
    test "Non-nil" do
      assert is_maybe_boolean(true)
      assert is_maybe_boolean(false)
    end

    test "Nil value" do
      assert is_maybe_boolean(nil)
    end
  end

  describe "is_maybe_pos_integer/1" do
    test "Non-nil" do
      assert is_maybe_pos_integer(5)
    end

    test "Non-nil negative" do
      refute is_maybe_pos_integer(-5)
    end

    test "Nil value" do
      assert is_maybe_pos_integer(nil)
    end
  end

  describe "is_maybe_list/1" do
    test "Non-nil" do
      assert is_maybe_list([])
    end

    test "Nil value" do
      assert is_maybe_list(nil)
    end
  end
end

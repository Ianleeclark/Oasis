defmodule Oasis.Parser.ReferenceTest do
  use ExUnit.Case

  alias Oasis.Parser.Reference

  import ExUnitProperties

  property "Constructs normally" do
    check all(ref <- StreamData.string(:ascii)) do
      %Reference{ref: result} = Reference.new(ref)

      assert result == ref
    end
  end
end

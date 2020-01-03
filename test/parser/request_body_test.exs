defmodule Oasis.Parser.RequestBodyTest do
  use ExUnit.Case

  alias Oasis.Parser.{Schema, RequestBody, MediaType}

  setup_all do
    schema = %Schema{
      type: :object,
      properties: %{
        "test_field" => %Schema{type: :boolean},
        "string_field" => %Schema{type: :string, format: :date}
      }
    }

    media_type = MediaType.new(schema, "encoding")

    %{schema: schema, media_type: media_type}
  end

  describe "new/3" do
    test "Echoes correct information", %{media_type: media_type} do
      content = %{"application/json" => media_type}
      request_body = RequestBody.new("foobar", content, false)

      assert request_body.description == "foobar"
      assert request_body.content == content
      refute request_body.required?
    end
  end

  describe "from_map/1" do
    test "Echoes correct information w/o content" do
      input = %{"description" => "foobar", "required" => true}
      request_body = RequestBody.from_map(input)

      assert request_body.content == %{}
      assert request_body.description == "foobar"
      assert request_body.required?
    end
  end
end

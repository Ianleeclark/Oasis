alias Oasis.Parser.{Schema, RequestBody, MediaType, Operation}
alias Oasis.Schemas

schema = %Schema{type: :object, properties: %{"asdf" => %Schema{type: :boolean}}}

request_body = %RequestBody{
  description: nil,
  content: %{"application/json" => %MediaType{schema: schema, encoding: "test"}},
  required?: true
}

operation = Operation.new("test_operation", %{}, request_body, %{}, [], false, %{})
contents = Schemas.create_ecto_schema(operation)

Module.create(Oasis.TestSchema, contents, __ENV__)

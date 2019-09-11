defmodule Oasis.Parser do
  alias Oasis.Parser.{Metadata, Operation, Path, Swagger}

  @spec load_json(raw_json :: String.t()) :: map()
  def load_json(raw_json) when is_binary(raw_json) do
    raw_json
    |> Jason.load!()
  end

  @spec map_json_map_to_swagger_struct(json_map :: map()) :: Swagger.t()
  def map_json_map_to_swagger_struct(json_map) when is_map(json_map) do
  end

  @spec extract_metadata_from_operations(swagger_data :: Swagger.t()) :: %{
          String.t() => Metadata.t()
        }
  def extract_metadata_from_operations(%Swagger{paths: paths} = swagger_data)
      when is_struct(swagger_data) do
    paths
    |> Enum.map(fn path ->
      Path.new()
    end)
  end
end

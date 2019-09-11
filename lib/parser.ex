defmodule Oasis.Parser do
  @moduledoc """
  Parses the JSON output of OAS 3.0 spec into useful metadata.

  This is one of the pieces to the puzzle. This primarily is concerned with telling
  the later steps in the process what API calls are available, what they expect, and
  all that good stuff.
  """

  alias Oasis.Parser.{Metadata, Operation, Path, Swagger}

  @doc """
  This is a roll-up of the following functions. It maps operation_ids to metadata.
  """
  @spec load(raw_json :: binary()) :: %{(operation_id :: String.t()) => Metadata.t()}
  def load(raw_json) when is_binary(raw_json) do
    raw_json
    |> load_json()
    |> map_json_to_swagger_struct()
    |> extract_metadata_from_operations()
  end

  @doc """
  Takes a raw blob of json and returns an elixir map.
  """
  @spec load_json(raw_json :: binary()) :: map()
  def load_json(raw_json) when is_binary(raw_json) do
    raw_json
    |> Jason.load!()
  end

  # TODO(ian): Verify the type linking below actually works -- do I need /0
  @doc """
  Takes an elixir map and converts it to a `t:Swagger.t/0`

  This allows easier metadata generation by pre-selecting all of the useful
  information into an easy-to-access structure.
  """
  @spec map_json_to_swagger_struct(json_map :: map()) :: Swagger.t()
  def map_json_to_swagger_struct(json_map) when is_map(json_map) do
    path_lookup_table =
      json_map["paths"]
      |> Enum.into(%{}, fn {path, operation_data} ->
        {path, Path.from_json(operation_data)}
      end)

    Swagger.new(
      json_map["version"],
      json_map["security"],
      path_lookup_table,
      json_map["components"]
    )
  end

  @doc """
  Generates `t:Metadata.t/0` from the `t:Swagger.t/0` data.

  These metadata entries will be used to generate functions to generate API calls.
  """
  @spec extract_metadata_from_operations(swagger_data :: Swagger.t()) :: %{
          (operation_id :: String.t()) => Metadata.t()
        }
  def extract_metadata_from_operations(%Swagger{paths: paths}) do
    paths
    |> Enum.into(%{}, fn %Path{} = path ->
      Enum.into(%{}, Path.all_http_methods(), fn http_method ->
        %Operation{} = operation = Map.get(path, http_method)

        metadata =
          Metadata.new(
            operation.request_body,
            operation.requires_auth?,
            operation.responses,
            operation.parameters,
            path,
            http_method
          )

        Map.new()
        |> Map.put(operation.operation_id, metadata)
      end)
    end)
  end
end

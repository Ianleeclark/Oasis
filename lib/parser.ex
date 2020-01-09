defmodule Oasis.Parser do
  @moduledoc """
  Parses the JSON output of OAS 3.0 spec into useful metadata.

  This is one of the pieces to the puzzle. This primarily is concerned with telling
  the later steps in the process what API calls are available, what they expect, and
  all that good stuff.
  """

  alias Oasis.Parser.{Components, Metadata, OAS, Operation, Path}
  alias Oasis.Schemas.Repo

  @doc """
  This is a roll-up of the following functions. It maps operation_ids to metadata.
  """
  @spec load(raw_json :: binary()) :: %{(operation_id :: String.t()) => Metadata.t()}
  def load(raw_json) when is_binary(raw_json) do
    with {:ok, json_map} <- load_json(raw_json),
         :ok <- preload_schemas_into_repo(Map.get(json_map, "components")),
         {:ok, %OAS{} = oas} <- map_json_to_oas_struct(json_map) do
      extract_metadata_from_operations(oas)
    end
  end

  @spec preload_schemas_into_repo(OAS.t()) :: :ok | {:error, atom()}
  defp preload_schemas_into_repo(%{"schemas" => schemas}) when is_map(schemas) do
    schemas
    |> Enum.map(fn {schema_name, schema} ->
      Repo.store_schema_by_name(schema_name, schema)
    end)
    |> Enum.uniq()
    |> case do
      [:ok] ->
        :ok

      [:ok, error] ->
        error
    end
  end

  defp preload_schemas_into_repo(%OAS{components: %Components{schemas: schemas}})
       when is_nil(schemas),
       do: :ok

  defp preload_schemas_into_repo(%OAS{components: %Components{schemas: schemas}})
       when is_map(schemas) do
    schemas
    |> Enum.map(fn {schema_name, schema} ->
      Repo.store_schema_by_name(schema_name, schema)
    end)
    |> Enum.uniq()
    |> case do
      [:ok] ->
        :ok

      [:ok, error] ->
        error
    end
  end

  @doc """
  Takes a raw blob of json and returns an elixir map.
  """
  @spec load_json(raw_json :: binary()) :: {:ok, map()} | {:error, :invalid_json}
  def load_json(raw_json) when is_binary(raw_json) do
    raw_json
    |> Jason.decode()
    |> case do
      {:ok, json_string} when is_binary(json_string) ->
        {:ok, Jason.decode!(json_string)}

      {:ok, json_map} = retval when is_map(json_map) ->
        retval

      {:error, _} ->
        {:error, :invalid_json}
    end
  end

  @doc """
  Takes an elixir map and converts it to a `t:OAS.t/0`

  This allows easier metadata generation by pre-selecting all of the useful
  information into an easy-to-access structure.
  """
  @spec map_json_to_oas_struct(json_map :: map()) :: {:ok, OAS.t()} | {:error, :invalid_api_spec}
  def map_json_to_oas_struct(json_map) when is_map(json_map) do
    case Map.has_key?(json_map, "paths") do
      true ->
        path_lookup_table =
          json_map["paths"]
          |> Enum.into(%{}, fn {path, operation_data} ->
            {path, Path.from_map(path, operation_data)}
          end)

        {:ok,
         OAS.new(
           json_map["version"],
           json_map["security"],
           path_lookup_table,
           json_map["components"]
         )}

      false ->
        {:error, :invalid_api_spec}
    end
  end

  @doc """
  Generates `t:Metadata.t()/0` from the `t:OAS.t()` data.

  These metadata entries will be used to generate functions to generate API calls.
  """
  @spec extract_metadata_from_operations(oas_data :: OAS.t()) ::
          {:ok,
           %{
             (operation_id :: String.t()) => Metadata.t()
           }}
  def extract_metadata_from_operations(%OAS{paths: paths}) when is_map(paths) do
    retval =
      paths
      |> Enum.flat_map(fn {_operation_id, %Path{uri: uri} = top_level_path} ->
        # We need to iterate over each and every key in the `Path.t()`, so we use the
        # `all_http_methods` function to grab all keys (besides house-keeping stuff like `uri`)
        Path.all_http_methods()
        |> Enum.into(%{}, fn http_method ->
          {http_method, Map.get(top_level_path, http_method)}
        end)
        |> Enum.map(fn
          {_http_method, {:error, _error_reason}} ->
            # TODO(ian): Debug warning if this is hit?
            nil

          # See comments below, but we discard this info if there is nothing useful here.
          {_http_method, nil} ->
            nil

          {http_method, %Operation{} = operation} ->
            alias Oasis.Schemas

            metadata =
              Metadata.new(
                Schemas.create_ecto_schema(operation),
                operation.requires_auth?,
                operation.responses,
                operation.parameters,
                uri,
                http_method
              )

            {operation.operation_id, metadata}
        end)
        # Get rid of any nil data. This basically means that, if there is no metadata about
        # the endpoint, then there is no usable information, so no need to keep it around.
        |> Enum.filter(fn x -> not is_nil(x) end)
        # Put all of the {operation_id, metadata pairs} into one big map to make easy to
        # look into
        |> Enum.into(%{})
      end)
      # At this point, we'll have a single list (due to `flat_map`) of many different maps.
      # These `operationIds` are guaranteed to be unique, so we can collapse into a single map.
      |> Enum.into(%{})

    {:ok, retval}
  end
end

defmodule Oasis.Schemas.Repo do
  @moduledoc """
  Stores schema references for later lookup.
  """

  use GenServer

  @ets_table_name :oasis_schema_repo

  #########################
  # GenServer Boilerplate #
  #########################

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    ets_table = :ets.new(@ets_table_name, [])
    {:ok, ets_table}
  end

  ##############
  # Public API #
  ##############

  @doc """
  Easy-to-consume function to store schemas. Prefer this above GenServer calls.
  """
  @spec store_schema_by_name(name :: String.t(), schema :: map()) :: map()
  def store_schema_by_name(name, schema)
      when is_binary(name) and is_map(schema) do
    GenServer.call(Process.whereis(Oasis.Schemas.Repo), {:store_schema, name, schema})
  end

  @doc """
  Easy-to-consume function to retrieve schemas. Prefer this above GenServer calls.
  """
  @spec fetch_schema_by_name(name :: String.t()) :: {:ok, map()}
  def fetch_schema_by_name(name) when is_binary(name) do
    GenServer.call(Process.whereis(Oasis.Schemas.Repo), {:fetch_schema, name})
  end

  #################
  # Genserver API #
  #################

  def handle_call({:store_schema, schema_name, schema}, _from, state)
      when is_binary(schema_name) and is_map(schema) do
    case store_schema(state, schema_name, schema) do
      :ok ->
        {:reply, :ok, state}
    end
  end

  def handle_call({:fetch_schema, schema_name}, _from, state)
      when is_binary(schema_name) do
    case fetch_schema(state, schema_name) do
      retval ->
        {:reply, retval, state}
    end
  end

  ######################################
  # Internal API for challenge storage #
  ######################################

  @spec store_schema(table :: atom(), schema_name :: String.t(), schema :: map()) ::
          :ok | {:error, atom}
  defp store_schema(table, schema_name, schema)
       when is_binary(schema_name) and is_map(schema) do
    case :ets.insert(table, {schema_name, schema}) do
      true ->
        :ok
    end
  end

  @spec fetch_schema(table :: atom(), schema_name :: String.t()) :: {:ok, map()} | {:error, atom}
  defp fetch_schema(table, schema_name)
       when is_binary(schema_name) do
    case :ets.lookup(table, schema_name) do
      [{^schema_name, schema}] ->
        {:ok, schema}

      [{^schema_name, schema} | _rest] ->
        {:ok, schema}

      [] ->
        {:error, :no_schema_found}
    end
  end
end

defmodule Oasis.Schemas.RepoTest do
  use ExUnit.Case

  alias Oasis.Schemas.Repo

  setup_all do
    schema = %{foo: "bar"}

    %{schema: schema}
  end

  describe "store_schema/3" do
    test "Insert unknown schema", %{schema: schema} do
      assert Repo.store_schema_by_name(Process.whereis(Repo), "unknown_schema", schema) == :ok
    end
  end

  describe "retrieve_schema/2" do
    test "Unknown schema name" do
      assert {:error, :no_schema_found} == Repo.fetch_schema_by_name(Process.whereis(Repo), "dfd")
    end

    test "Known schema name", %{schema: schema} do
      assert Repo.store_schema_by_name(Process.whereis(Repo), "unknown_schema", schema) == :ok
      retval = Repo.fetch_schema_by_name(Process.whereis(Repo), "unknown_schema")

      assert elem(retval, 0) == :ok
      assert elem(retval, 1) == schema
      assert Map.get(elem(retval, 1), :foo) == "bar"
    end
  end
end

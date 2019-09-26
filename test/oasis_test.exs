defmodule OasisTest do
  use ExUnit.Case
  doctest Oasis

  describe "register_endpoints_from_filename/1" do
    test "Ensure created functions have correct return values" do
      Oasis.register_endpoints_from_filename("test.json")

      sub_post =
        Oasis.Endpoints.subscriptions_post(
          %{foo: 'bar'},
          {'Content-Type', 'application/json'}
        )

      sub_put =
        Oasis.Endpoints.subscriptions_put(
          %{foo: 'bar'},
          {'Content-Type', 'application/json'}
        )

      sub_delete = Oasis.Endpoints.subscriptions_delete()

      users_post =
        Oasis.Endpoints.users_post(
          %{foo: 'bar'},
          {'Content-Type', 'application/json'}
        )

      users_put =
        Oasis.Endpoints.users_put(
          %{foo: 'bar'},
          {'Content-Type', 'application/json'}
        )

      users_delete = Oasis.Endpoints.users_delete()

      [sub_post, sub_put, users_post, users_put]
      |> Enum.map(fn {retval, {_uri, body, headers, opts}} ->
        assert retval == :ok
        assert body == %{foo: 'bar'}
        assert headers == {'Content-Type', 'application/json'}
        assert opts == []
      end)

      [sub_delete, users_delete]
      |> Enum.map(fn {retval, {_uri, headers, opts}} ->
        assert retval == :ok
        assert headers == []
        assert opts == []
      end)
    end
  end
end

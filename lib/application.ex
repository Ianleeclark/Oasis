defmodule Oasis.App do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Oasis.Schemas.Repo, [])
    ]

    {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  end
end

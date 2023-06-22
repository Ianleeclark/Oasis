defmodule Oasis.MixProject do
  use Mix.Project

  def project do
    [
      app: :oasis,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      aliases: aliases(),
      # TODO(ian): Turn on warnings as errors?
      elixirc_options: [warnings_as_errors: false],
      # Make sure that `testall` always runs under `MIX_ENV=test`
      preferred_cli_env: [test: :test]
    ]
  end

  def aliases, do: []

  def application do
    [
      extra_applications: [:logger],
      mod: {Oasis.App, []}
    ]
  end

  defp deps do
    [
      # Core dependencies
      ## Json parsing.
      {:jason, "~> 1.1"},
      ## Does schema validation for requests
      {:ecto, "~> 3.1.0"},

      # Developer dependencies
      ## Keep code complexity moderately low
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      ## Add some level of type-safety
      {:dialyxir, "~> 0.5.1", only: [:dev, :test], runtime: false},
      ## Property testing
      {:stream_data, "~> 0.5", only: :test},
      ## Documentation + Deployments
      {:ex_doc, "~> 0.21", only: [:dev, :test], runtime: false},
      ## Used for testing the HTTP behavior and during testing
      {:httpoison, "~> 1.5.1", only: [:dev, :test]},
      ## Shows coverage % for tests
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end

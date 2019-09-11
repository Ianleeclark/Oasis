defmodule Oasis.MixProject do
  use Mix.Project

  def project do
    [
      app: :oasis,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Core dependencies
      ## Json parsing.
      {:jason, "~> 1.1"},
      ## Lenses to make working with nested data easier
      {:focus, "~> 0.3.5"},

      # Developer dependencies
      ## Keep code complexity moderately low
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      ## Add some level of type-safety
      {:dialyxir, "~> 0.5.1", only: [:dev, :test], runtime: false},
      ## Property testing
      {:stream_data, "~> 0.1", only: :test},
      ## Documentation + Deployments
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
end

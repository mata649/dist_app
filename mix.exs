defmodule DistApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :dist_app,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DistApp.Application, []},
      start_phases: [start_worker_supervisor: []]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3.2"},
      {:horde, "~> 0.8.7"},
      {:poolboy, "~> 1.5.1"}


    ]
  end
end

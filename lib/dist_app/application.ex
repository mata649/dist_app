defmodule DistApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger
  @impl true
  def start(_type, _args) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: DistApp.ClusterSupervisor]]},
      {Horde.Registry, [name: DistApp.Registry, keys: :unique, members: :auto]},
      {Horde.DynamicSupervisor,
       [name: DistApp.HordeSupervisor, strategy: :one_for_one, members: :auto]},
    ]

    opts = [strategy: :one_for_one, name: DistApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def start_phase(:start_worker_supervisor, :normal, _options) do
    Logger.info("Starting Workers Supervisor")
    Horde.DynamicSupervisor.start_child(DistApp.HordeSupervisor, DistApp.WorkerSupervisor)
    :ok
  end
  defp topologies,
    do: [
      gossip: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
end

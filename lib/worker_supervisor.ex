defmodule DistApp.WorkerSupervisor do
  use Supervisor
  require Logger

  def child_spec(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    %{
      id: "#{__MODULE__}_#{name}",
      start: {__MODULE__, :start_link, [name]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(name) do
    case Supervisor.start_link(__MODULE__, [], name: via_tuple(name)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  def via_tuple(name), do: {:via, Horde.Registry, {DistApp.Registry, name}}

  def init([]) do
    children = [
      :poolboy.child_spec(DistApp.SayHello, poolboy_config())
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp poolboy_config do
    [
      name: {:local, DistApp.SayHello},
      worker_module: DistApp.SayHello,
      size: 5,
      max_overflow: 2
    ]
  end
end

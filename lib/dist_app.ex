defmodule DistApp.SayHello do
  use GenServer
  require Logger

  def start_link(_) do
    case GenServer.start_link(__MODULE__, []) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  def init(_args) do
    {:ok, nil}
  end

  def print_message(message),
    do:
      :poolboy.transaction(__MODULE__, fn pid ->
        GenServer.call(pid, {:print, message})
      end)

  def handle_call({:print, message}, from, state) do
    from_pid = elem(from, 0)
    IO.puts("[Message - #{inspect(self())}]: #{message}, from #{inspect(from_pid)}")
    {:reply, message, state}
  end
end

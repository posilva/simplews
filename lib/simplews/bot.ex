defmodule SimpleWS.Bot do
  @moduledoc """
    Bot module responsible for managing the lifecycle of a 
    bot connected to the websocket
  """
  alias SimpleWS.Bot.{Client, Supervisor}

  use GenServer

  require Logger

  def start_link(args) do
    Logger.info("bot init args #{inspect(args)}")
    GenServer.start_link(__MODULE__, args)
  end

  @impl GenServer
  def init(args) do
    Process.flag(:trap_exit, true)
    Process.send_after(self(), :disconnect, Enum.random(10_000..50_000))
    Logger.info("bot init args #{inspect(args)}")

    state = %{
      client: nil,
      uri: args[:uri],
      state: args[:state],
      opts: args[:opts]
    }

    Logger.info("bot init state #{inspect(state)}")
    {:ok, state, {:continue, :connect}}
  end

  def new(n \\ 1) when is_integer(n) and n > 0 do
    Enum.map(1..n, fn _ -> Supervisor.start_child(nil) end)
  end

  @impl GenServer
  def handle_continue(:connect, state) do
    {:ok, client} =
      Client.start_link(
        uri: state[:uri],
        state: state[:state] || %{},
        opts: state[:opts] || []
      )

    {:noreply, %{state | client: client}}
  end

  @impl GenServer
  def handle_info(:disconnect, state) do
    Logger.info("bot is disconnecting")
    Process.send(state.client, :stop, [])
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end

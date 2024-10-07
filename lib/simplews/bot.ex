defmodule SimpleWS.Bot do
  use GenServer

  require Logger

  def start_link(args) do
    Logger.info("bot init args #{inspect(args)}")
    GenServer.start_link(__MODULE__, args)
  end

  @impl GenServer
  def init(args) do
    Process.flag(:trap_exit, true)

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
    Enum.map(1..n, fn _ -> SimpleWS.Bot.Supervisor.start_child(nil) end)
  end

  @impl GenServer
  def handle_continue(:connect, state) do
    {:ok, client} =
      SimpleWS.Bot.Client.start_link(
        uri: state[:uri],
        state: state[:state] || %{},
        opts: state[:opts] || []
      )

    {:noreply, %{state | client: client}}
  end
end

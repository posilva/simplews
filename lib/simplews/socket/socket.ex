defmodule SimpleWS.Socket do
  require Logger
  @behaviour WebSock

  @impl WebSock
  def init(%{client_ip: c_ip}) do
    state = %{
      client_ip: c_ip
    }

    SimpleWS.Telemetry.connection_inc()
    Logger.info("init state: #{inspect(state)}")
    {:ok, state}
  end

  @impl WebSock
  def handle_in({text, [opcode: :text]}, state) do
    {:reply, :ok, {:text, text}, state}
  end

  @impl WebSock
  def handle_info(msg, state) do
    Logger.info("handle_info: #{inspect(msg)}")
    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) do
    SimpleWS.Telemetry.connection_dec()
    Logger.info("terminate: #{inspect(reason)}")

    {:stop, reason, state}
  end
end

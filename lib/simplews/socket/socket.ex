defmodule SimpleWS.Socket do
  require Logger
  @behaviour WebSock

  @impl WebSock
  def init(%{client_ip: c_ip}) do
    state = %{
      client_ip: c_ip
    }

    Logger.info("init state: #{inspect(state)}")
    {:ok, state}
  end

  @impl WebSock
  def handle_in({text, [opcode: :text]}, state) do
    Logger.info("handle_in: #{inspect(text)}")
    {:reply, :ok, {:text, text}, state}
  end

  @impl WebSock
  def handle_info(msg, state) do
    Logger.info("handle_info: #{inspect(msg)}")
    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) do
    Logger.info("terminate: #{inspect(reason)}")

    {:stop, reason, state}
  end
end

defmodule Simplews.Socket.Handler do
  @behaviour WebSock
  require Logger

  @impl WebSock
  def init(args) do
    Logger.info("hadler init: #{args}")
    state = %{}
    {:ok, state}
  end

  @impl WebSock
  def handle_in({:text, text}, state) do
    Logger.info("handle in: #{text}")
    {:reply, :ok, {:text, text}, state}
  end

  @impl WebSock
  def handle_info(msg, state) do
    Logger.info("hanlde info #{msg}")

    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) do
    Logger.info("terminante: #{reason}")
    {:stop, reason, state}
  end
end

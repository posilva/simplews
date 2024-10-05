defmodule SimpleWS.Socket do
  require Logger

  def init(args) do
    Logger.info("init socket: #{args}")
    state = %{}
    {:ok, state}
  end

  def handle_in({:text, msg}, state) do
    Logger.info("handle_in: #{msg}")
    {:reply, :ok, {:text, msg}, state}
  end

  def handle_info(msg, state) do
    Logger.info("handle_info: #{msg}")
    {:ok, state}
  end

  def terminate(reason, state) do
    Logger.info("terminate: #{reason}")
    {:stop, reason, state}
  end
end

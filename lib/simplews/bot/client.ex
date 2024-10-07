defmodule SimpleWS.Bot.Client do
  use Fresh

  require Logger

  def handle_connect(_status, _headers, state) do
    Logger.info("bot client handle connect: #{inspect(state)}")
    {:reply, {:text, state}, state}
  end

  def handle_in({:text, state}, state) do
    Logger.info("bot client handle in: #{inspect(state)}")
    {:reply, {:text, "1"}, 0}
  end

  def handle_in({:text, number}, _state) do
    number = String.to_integer(number)

    {:reply, {:text, "#{number + 1}"}, number}
  end

  def handle_info(:stop, state) do
    {:reply, {:close, 1002, "example"}, state}
  end

  def handle_disconnect(_code, _reason, _state) do
    :close
  end
end

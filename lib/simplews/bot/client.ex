defmodule SimpleWS.Bot.Client do
  @moduledoc """
    Websocket client implemented using Fresh
  """
  use Fresh

  require Logger

  def handle_connect(_status, _headers, state) do
    Logger.info("bot client handle connect: #{inspect(state)}")
    {:reply, {:text, state}, state}
  end

  def handle_in({:text, state}, state) do
    {:reply, {:text, "1"}, 0}
  end

  def handle_in({:text, number}, _state) do
    number = String.to_integer(number)
    Enum.random(100..2000) |> :timer.sleep()
    {:reply, {:text, "#{number + 1}"}, number}
  end

  def handle_info(:stop, state) do
    {:reply, {:close, 1002, "simplews"}, state}
  end

  def handle_disconnect(code, reason, _state) do
    Logger.info("handle disconnect #{inspect(code)} #{inspect(reason)}")
    :close
  end

  def handle_error({error, reason}, state) do
    Logger.info("handling error and ignoring  #{inspect({error, reason})}")
    {:ignore, state}
  end

  def handle_error(error, _state) do
    Logger.info("handling error and reconnecting #{error}")
    :reconnect
  end
end

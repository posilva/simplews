defmodule SimpleWS do
  @moduledoc """
  Documentation for `SimpleWS`.
  """
  require Logger

  def send_metric() do
    :telemetry.execute([:http, :request, :mycontroller], %{count: 1})
  end

  def new_bot() do
    SimpleWS.Bot.Supervisor.start_child(%{
      uri: "ws://localhost:4001/server",
      state: "1"
    })
  end
end

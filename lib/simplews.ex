defmodule SimpleWS do
  @moduledoc """
  Documentation for `SimpleWS`.
  """
  require Logger

  def send_metric do
    :telemetry.execute([:http, :request, :mycontroller], %{count: 1})
  end

  def new_bot(count \\ 1, url \\ "ws://localhost:4000/server") do
    Enum.map(1..count, fn _ ->
      SimpleWS.Bot.Supervisor.start_child(%{
        uri: url,
        state: "1"
      })
    end)
  end
end

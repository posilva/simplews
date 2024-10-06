defmodule SimpleWS do
  @moduledoc """
  Documentation for `SimpleWS`.
  """
  require Logger

  def send_metric() do
    :telemetry.execute([:http, :request, :mycontroller], %{count: 1})
  end
end

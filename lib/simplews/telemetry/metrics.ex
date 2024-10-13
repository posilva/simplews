defmodule SimpleWS.Telemetry.Metrics do
  @moduledoc """
    Module to manage all the application metrics 
  """
  import Telemetry.Metrics

  @active_connections_metric [:simplews, :connections]
  @total_active_conns_name Enum.join(@active_connections_metric, ".")

  @rate_limited_requests_metric [:simplews, :requests, :limited]
  @rate_limited_requests_name Enum.join(@rate_limited_requests_metric, ".")

  def report() do
    [
      # VM Metrics
      last_value("vm.memory.total", unit: {:byte, :kilobyte}),
      last_value("vm.total_run_queue_lengths.total"),
      last_value("vm.total_run_queue_lengths.cpu"),
      last_value("vm.total_run_queue_lengths.io"),
      # app metrics
      last_value("#{@total_active_conns_name}.count"),
      counter("#{@rate_limited_requests_name}.count")
    ]
  end

  def periodic() do
    # A module, function and arguments to be invoked periodically.
    # This function must call :telemetry.execute/3 and a metric must be added above.
    [{__MODULE__, :get_active_connections, []}]
  end

  def get_active_connections() do
    {:ok, count} = SimpleWS.Telemetry.get_counter(@total_active_conns_name)
    :telemetry.execute(@active_connections_metric, %{count: count}, %{})
  end

  def active_connections_increment() do
    SimpleWS.Telemetry.counter_inc(@total_active_conns_name)
  end

  def active_connections_decrement() do
    SimpleWS.Telemetry.counter_dec(@total_active_conns_name)
  end

  def rate_limited() do
    :telemetry.execute(@rate_limited_requests_metric, %{count: 1}, %{})
  end
end

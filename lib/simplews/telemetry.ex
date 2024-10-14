defmodule SimpleWS.Telemetry do
  @moduledoc """
    Module to handle telemetry under the supervision tree.
  """
  use Supervisor

  alias SimpleWS.Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    :ets.new(__MODULE__, [
      :named_table,
      :set,
      :public,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ])

    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: Metrics.periodic(), period: 5_000},
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
      {TelemetryMetricsPrometheus, [metrics: Metrics.report()]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def counter_inc(name) do
    _ = :ets.update_counter(__MODULE__, {:counter, name}, {2, 1}, {{:counter, name}, 0})
  end

  def counter_dec(name) do
    _ = :ets.update_counter(__MODULE__, {:counter, name}, {2, -1}, {{:counter, name}, 0})
  end

  def get_counter(name) do
    count =
      case :ets.lookup(__MODULE__, {:counter, name}) do
        [{{:counter, _name}, count}] -> count
        _ -> 0
      end

    {:ok, count}
  end
end

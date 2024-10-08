defmodule SimpleWS.Telemetry do
  use Supervisor

  import Telemetry.Metrics

  require Logger

  @total_connection_metric "simplews.connections"

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
      {:telemetry_poller, measurements: periodic_measurements(), period: 5_000},
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
      {TelemetryMetricsPrometheus, [metrics: metrics()]}
    ]

    setup()
    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      last_value("simplews.connections.count"),
      # VM Metrics
      last_value("vm.memory.total", unit: {:byte, :kilobyte}),
      last_value("vm.total_run_queue_lengths.total"),
      last_value("vm.total_run_queue_lengths.cpu"),
      last_value("vm.total_run_queue_lengths.io"),
      sum("http.request.mycontroller.count")
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      {__MODULE__, :get_current_connections, []}
    ]
  end

  def counter_inc(name) do
    b = :ets.update_counter(__MODULE__, {:counter, name}, {2, 1})
    Logger.info("counter_inc: #{inspect({name, b})}")
  end

  def counter_dec(name) do
    b = :ets.update_counter(__MODULE__, {:counter, name}, {2, -1})
    Logger.info("counter_dec: #{inspect({name, b})}")
  end

  def get_current_connections() do
    [{{:counter, @total_connection_metric}, count}] =
      :ets.lookup(
        __MODULE__,
        {:counter, @total_connection_metric}
      )

    Logger.info("get_current_connections: #{count}")
    :telemetry.execute([:simplews, :connections], %{count: count}, %{})
  end

  def connection_inc() do
    counter_inc(@total_connection_metric)
  end

  def connection_dec() do
    counter_dec(@total_connection_metric)
  end

  defp setup() do
    init_counter(@total_connection_metric)
  end

  defp init_counter(name) do
    :ets.insert(__MODULE__, {{:counter, name}, 0})
  end
end

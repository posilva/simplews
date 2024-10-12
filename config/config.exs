import Config

# config :opentelemetry, :processors,
#  otel_batch_processor: %{
#    exporter: {:otel_exporter_stdout, []}
#  }
config :opentelemetry, :resource, service: %{name: "simplews"}

config :opentelemetry,
  span_processor: :batch,
  traces_exporter: :otlp

config :opentelemetry_exporter,
  otlp_protocol: :grpc,
  otlp_endpoint: "http://localhost:4317"

config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

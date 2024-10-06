import Config

config :opentelemetry, :resource, service: %{name: "simplews"}

config :opentelemetry, :processors,
  otel_batch_processor: %{
    exporter: {:opentelemetry_exporter, %{endpoints: ["http://localhost:4317"]}}
  }

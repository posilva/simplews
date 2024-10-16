import Config

otel_host = System.get_env("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4317")
config :opentelemetry, :resource, service: %{name: "simplews"}

config :opentelemetry, :processors,
  otel_batch_processor: %{
    exporter: {
      :opentelemetry_exporter,
      %{endpoints: [otel_host]}
    }
  }

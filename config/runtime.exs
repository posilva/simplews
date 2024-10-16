import Config

config :opentelemetry, :resource, service: %{name: "simplews"}

config :opentelemetry, :processors,
  otel_batch_processor: %{
    otel_host = System.get_env("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4317")
    exporter: {
        :opentelemetry_exporter, %{endpoints: [otel_host]}
    }
  }


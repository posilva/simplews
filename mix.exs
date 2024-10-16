defmodule SimpleWS.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :simplews,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.cobertura": :test
      ],
      releases: [
        simplews: [
          applications: [opentelemetry_exporter: :permanent, opentelemetry: :temporary]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :recon],
      mod: {SimpleWS.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mint_web_socket, "~> 1.0"},
      {:bandit, "~> 1.0"},
      {:websock_adapter, "~> 0.5.7"},
      {:websock, "~> 0.5"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.1"},
      {:telemetry, "~> 1.0"},
      {:opentelemetry_exporter, "~> 1.7.0"},
      {:opentelemetry_api, "~> 1.3.1"},
      {:opentelemetry, "== 1.4.0"},
      {:opentelemetry_bandit, "~> 0.1.4"},
      {:telemetry_metrics_prometheus, "~> 1.1.0"},
      {:protox, "~> 1.7"},
      {:phoenix_pubsub, "~> 2.1"},
      {:phoenix, "~> 1.7", optional: true},
      {:hammer, "~> 6.2"},
      {:fresh, "~> 0.4"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, ">= 0.0.0", only: :docs},
      {:recon, "~> 2.5"},
      {:jason, "~> 1.4"}
    ]
  end
end

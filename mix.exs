defmodule SimpleWS.MixProject do
  use Mix.Project

  def project do
    [
      app: :simplews,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
      extra_applications: [:logger],
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
      {:fresh, "~> 0.4.4"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

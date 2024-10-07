defmodule SimpleWS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: SimpleWS.Worker.start_link(arg)
      # {SimpleWS.Worker, arg}
      SimpleWS.Telemetry,
      {DynamicSupervisor, name: SimpleWS.Bot.Supervisor, strategy: :one_for_one},
      {Bandit, plug: SimpleWS.Socket.Plug, port: get_port()}
    ]

    OpentelemetryBandit.setup()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleWS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_port do
    port = System.get_env("SWS_PORT") || "4000"
    {port, _} = Integer.parse(port)
    port
  end
end

defmodule SimpleWS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Simplews.Worker.start_link(arg)
      # {Simplews.Worker, arg}
      SimpleWS.Telemetry,
      {Bandit, plug: SimpleWS.Socket.Plug}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleWS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

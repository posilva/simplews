defmodule SimpleWS.Bot.Supervisor do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: args)
  end

  def start_child(args) do
    spec = {SimpleWS.Bot, args}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end

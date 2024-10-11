defmodule SimpleWS.Socket do
  require Logger
  @behaviour WebSock

  @presence_topic "presence_state"

  @impl WebSock
  def init(%{client_ip: c_ip}) do
    state = %{
      client_ip: c_ip,
      key: nil
    }

    SimpleWS.Telemetry.connection_inc()
    Logger.info("init state: #{inspect(state)}")

    {:ok, state}
  end

  @impl WebSock
  def handle_in({data, [opcode: :binary]}, state) do
    {:reply, :ok, {:binary, data}, state}
  end

  def handle_in({<<"join::", uid::binary>>, [opcode: :text]}, state) do
    send(self(), {:after_join, uid})
    {:ok, state}
  end

  def handle_in({<<"list::">>, [opcode: :text]}, state) do
    send(self(), :report)
    {:ok, state}
  end

  def handle_in({data, [opcode: :text]}, state) do
    {:reply, :ok, {:text, data}, state}
  end

  @impl WebSock
  def handle_info(:report, state) do
    Logger.info(
      " Users Presence List: #{inspect(SimpleWS.Cluster.Presence.list(@presence_topic))}"
    )

    list = SimpleWS.Cluster.Presence.list(@presence_topic)
    {:reply, :ok, {:text, Jason.encode!(list)}, state}
  end

  def handle_info({:after_join, uid}, state) do
    send(self(), :report)
    uid_key = "user:#{uid}"

    {:ok, _} =
      SimpleWS.Cluster.Presence.track(
        self(),
        @presence_topic,
        uid_key,
        %{
          user_id: uid
        }
      )

    {:ok, %{state | key: uid_key}}
  end

  def handle_info(msg, state) do
    Logger.info("handle_info: #{inspect(msg)}")
    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) do
    SimpleWS.Telemetry.connection_dec()
    Logger.info("terminate: #{inspect(reason)}")
    SimpleWS.Cluster.Presence.untrack(self(), @presence_topic, state[:key])
    {:stop, reason, state}
  end
end

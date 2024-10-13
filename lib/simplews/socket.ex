defmodule SimpleWS.Socket do
  require Logger
  @behaviour WebSock

  @presence_topic "presence_state"

  @impl WebSock
  def init(%{client_ip: c_ip}) do
    state = %{
      client_ip: c_ip,
      key: nil,
      rate_limited_timer: nil
    }

    SimpleWS.Telemetry.Metrics.active_connections_increment()
    Logger.info("init state: #{inspect(state)}")

    {:ok, state}
  end


  def maybe_cancel_rate_limit(%{rate_limited_timer: rlref}=state) when not is_nil(rlref) do
    :timer.cancel(rlref)
    %{state | rate_limited_timer: nil}
  end
  def maybe_cancel_rate_limit(state), do: state

  @impl WebSock
  def handle_in(frame, state) do
    rlID = "ip::#{state[:client_ip]}"
    case SimpleWS.RateLimiter.allow(rlID) do
      :ok ->
        state = maybe_cancel_rate_limit(state)

        handle_frame(frame, state)

      :limit ->
        SimpleWS.Telemetry.Metrics.rate_limited()
        # throtle for random time
        timer_ref = Process.send_after(self(), :rate_limited, 3000)
        {:ok, %{state| rate_limited_timer: timer_ref}}
        #{:stop, :normal, 1013, state}
    end
  end

  def handle_frame({data, [opcode: :binary]}, state) do
    {:reply, :ok, {:binary, data}, state}
  end

  def handle_frame({<<"join::", uid::binary>>, [opcode: :text]}, state) do
    send(self(), {:after_join, uid})
    {:ok, state}
  end

  def handle_frame({<<"list::">>, [opcode: :text]}, state) do
    send(self(), :report)
    {:ok, state}
  end

  def handle_frame({data, [opcode: :text]}, state) do
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
  def handle_info(:rate_limited, state) do
    {:stop, :normal, 1013, state}
  end

  def handle_info(msg, state) do
    Logger.info("handle_info: #{inspect(msg)}")
    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) do
    SimpleWS.Telemetry.Metrics.active_connections_decrement()
    SimpleWS.Cluster.Presence.untrack(self(), @presence_topic, state[:key])
    {:stop, reason, state}
  end
end

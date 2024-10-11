defmodule SimpleWS.Cluster.Presence do
  use Phoenix.Presence,
    otp_app: :simplews,
    pubsub_server: SimpleWS.Cluster.PubSub
end

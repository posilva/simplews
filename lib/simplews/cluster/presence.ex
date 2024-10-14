defmodule SimpleWS.Cluster.Presence do
  @moduledoc """
    Presence module to integrate Phoenix Presence 
  """
  use Phoenix.Presence,
    otp_app: :simplews,
    pubsub_server: SimpleWS.Cluster.PubSub
end

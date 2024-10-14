defmodule SimpleWS.Socket.Plug do
  @moduledoc """
    Plug implementation to handle WebRequests upgrades and expose a route
  """
  use Plug.Router

  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  def init(opts) do
    Logger.info("plug init: #{inspect(opts)} ")
    opts
  end

  get "/server" do
    conn
    |> WebSockAdapter.upgrade(SimpleWS.Socket, %{client_ip: client_ip(conn)}, timeout: 60_000)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp client_ip(%{remote_ip: remote_ip} = conn) do
    case Plug.Conn.get_req_header(conn, "x-forwarded-for") do
      [] ->
        remote_ip
        |> :inet_parse.ntoa()
        |> to_string()

      [ip_address | _] ->
        ip_address
    end
  end
end

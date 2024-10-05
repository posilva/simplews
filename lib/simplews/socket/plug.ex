defmodule SimpleWS.Socket.Plug do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  def init(opts) do
    opts
  end

  get "/server" do
    conn
    |> WebSockAdapter.upgrade(SimpleWS.Socket, [], timeout: 60_000)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end

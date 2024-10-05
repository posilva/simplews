defmodule SimplewsTest do
  use ExUnit.Case

  test "simple connect" do
    connect()
  end

  test "simple echo" do
    {:ok, conn, websocket, ref} = connect()

    msg = "hello world"
    {:ok, websocket, data} = Mint.WebSocket.encode(websocket, {:text, msg})
    {:ok, conn} = Mint.WebSocket.stream_request_body(conn, ref, data)
    echo_message = receive(do: (message -> message))
    {:ok, _conn, [{:data, ^ref, data}]} = Mint.WebSocket.stream(conn, echo_message)
    {:ok, _websocket, [{:text, response}]} = Mint.WebSocket.decode(websocket, data)
    assert(msg == response)
  end

  defp connect(host \\ "localhost", port \\ 4_000) do
    {:ok, conn} = Mint.HTTP.connect(:http, host, port)
    {:ok, conn, ref} = Mint.WebSocket.upgrade(:ws, conn, "/server", [])
    http_reply_message = receive(do: (message -> message))

    {:ok, conn, [{:status, ^ref, status}, {:headers, ^ref, resp_headers}, {:done, ^ref}]} =
      Mint.WebSocket.stream(conn, http_reply_message)

    {:ok, conn, websocket} =
      Mint.WebSocket.new(conn, ref, status, resp_headers)

    {:ok, conn, websocket, ref}
  end
end

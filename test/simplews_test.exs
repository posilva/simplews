defmodule SimplewsTest do
  use ExUnit.Case

  test "simple connect" do
    connect()
  end

  defp connect(host \\ "localhost", port \\ 4_000) do
    {:ok, conn} = Mint.HTTP.connect(:http, host, port)
    {:ok, conn, ref} = Mint.WebSocket.upgrade(:ws, conn, "/server", [])
    http_reply_message = receive(do: (message -> message))

    {:ok, conn, [{:status, ^ref, status}, {:headers, ^ref, resp_headers}, {:done, ^ref}]} =
      Mint.WebSocket.stream(conn, http_reply_message)

    {:ok, _conn, _websocket} =
      Mint.WebSocket.new(conn, ref, status, resp_headers)
  end
end

defmodule SimpleWSTest do
  use ExUnit.Case

  alias SimpleWS.Proto

  require Logger

  test "simple connect" do
    connect()
  end

  test "simple text echo" do
    {:ok, conn, websocket, ref} = connect()

    msg = "hello world"
    socket = send_text({conn, websocket, ref}, msg)
    echo_message = receive(do: (message -> message))

    {:ok, _socket, 1, [{:text, response}]} = rcv(socket, echo_message)
    assert(msg == response)
  end

  test "simple proto exchange" do
    {:ok, conn, websocket, ref} = connect()

    {:ok, msg} = Proto.Echo.encode(%Proto.Echo{message: "protobuf hello!"})
    msg = IO.iodata_to_binary(msg)

    socket = send_bin({conn, websocket, ref}, msg)
    echo_message = receive(do: (message -> message))

    {:ok, _socket, 1, [{:binary, response}]} = rcv(socket, echo_message)
    assert(msg == response)
  end

  test "simple text echo presence" do
    {:ok, conn, websocket, ref} = connect()

    msg1 = "join::1"
    socket1 = send_text({conn, websocket, ref}, msg1)
    echo_message1 = receive(do: (message -> message))

    {:ok, _socket1, 1, [{:text, response1}]} = rcv(socket1, echo_message1)

    presence_list = Jason.decode!(response1)
    assert(Map.has_key?(presence_list, "user:1"))
    assert(Kernel.map_size(presence_list) == 1)

    # second client 
    {:ok, conn, websocket, ref} = connect()

    msg2 = "join::2"
    socket2 = send_text({conn, websocket, ref}, msg2)
    echo_message2 = receive(do: (message -> message))

    {:ok, __socket2, 1, [{:text, response2}]} = rcv(socket2, echo_message2)

    presence_list = Jason.decode!(response2)
    assert(Map.has_key?(presence_list, "user:2"))
    assert(Kernel.map_size(presence_list) == 2)
  end

  test "simple text disconnect test presence" do
    {:ok, conn, websocket, ref} = connect()
    {:ok, _socket, _response} = join({conn, websocket, ref}, "1")
    # second client 
    {:ok, conn2, websocket2, ref2} = connect()
    {:ok, _socket2, _response2} = join({conn2, websocket2, ref2}, "2")
    # third client 
    {:ok, conn3, websocket3, ref3} = connect()
    {:ok, _socket3, _response3} = join({conn3, websocket3, ref3}, "3")
    Mint.HTTP.close(conn2)
    :timer.sleep(100)
    {:ok, _socket, list} = list({conn, websocket, ref})

    assert(!Map.has_key?(list, "user:2"))
  end

  defp connect(host \\ "localhost", port \\ 4_000) do
    port = System.get_env("TEST_PORT", Integer.to_string(port))
    {port, _} = Integer.parse(port)
    {:ok, conn} = Mint.HTTP.connect(:http, host, port)
    {:ok, conn, ref} = Mint.WebSocket.upgrade(:ws, conn, "/server", [])
    http_reply_message = receive(do: (message -> message))

    {:ok, conn, [{:status, ^ref, status}, {:headers, ^ref, resp_headers}, {:done, ^ref}]} =
      Mint.WebSocket.stream(conn, http_reply_message)

    {:ok, conn, websocket} =
      Mint.WebSocket.new(conn, ref, status, resp_headers)

    {:ok, conn, websocket, ref}
  end

  defp send_text(ws, msg) do
    snd(ws, msg, :text)
  end

  defp send_bin(ws, msg) do
    snd(ws, msg, :binary)
  end

  defp snd({conn, ws, ref}, msg, type) do
    {:ok, ws, data} = Mint.WebSocket.encode(ws, {type, msg})
    {:ok, conn} = Mint.WebSocket.stream_request_body(conn, ref, data)
    {conn, ws, ref}
  end

  defp rcv({conn, ws, ref}, rcb) do
    {:ok, conn, [{:data, ^ref, data}]} = Mint.WebSocket.stream(conn, rcb)
    {:ok, ws, response} = Mint.WebSocket.decode(ws, data)
    {:ok, {conn, ws, ref}, length(response), response}
  end

  defp join({conn, websocket, ref}, uid) do
    msg = "join::#{uid}"
    user = "user:#{uid}"
    socket = send_text({conn, websocket, ref}, msg)
    echo_message = receive(do: (message -> message))

    {:ok, socket, 1, [{:text, response}]} = rcv(socket, echo_message)

    presence_list = Jason.decode!(response)
    assert(Map.has_key?(presence_list, user))
    assert(Kernel.map_size(presence_list) > 0)
    {:ok, socket, response}
  end

  defp list({conn, websocket, ref}) do
    msg = "list::"
    socket = send_text({conn, websocket, ref}, msg)
    echo_message = receive(do: (message -> message))

    {:ok, socket, 1, [{:text, response}]} = rcv(socket, echo_message)

    presence_list = Jason.decode!(response)
    assert(is_map(presence_list))
    {:ok, socket, presence_list}
  end
end

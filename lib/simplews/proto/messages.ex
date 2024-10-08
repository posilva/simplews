# credo:disable-for-this-file
[
  defmodule SimpleWS.Proto.Envelope.ContentType do
    @moduledoc false
    (
      defstruct []

      (
        @spec default() :: :UNKNOWN
        def default() do
          :UNKNOWN
        end
      )

      @spec encode(atom() | String.t()) :: integer() | atom()
      [
        (
          def encode(:UNKNOWN) do
            0
          end

          def encode("UNKNOWN") do
            0
          end
        ),
        (
          def encode(:REQUEST) do
            1
          end

          def encode("REQUEST") do
            1
          end
        ),
        (
          def encode(:RESPONSE) do
            2
          end

          def encode("RESPONSE") do
            2
          end
        ),
        (
          def encode(:ERROR) do
            3
          end

          def encode("ERROR") do
            3
          end
        )
      ]

      def encode(x) do
        x
      end

      @spec decode(integer()) :: atom() | integer()
      [
        def decode(0) do
          :UNKNOWN
        end,
        def decode(1) do
          :REQUEST
        end,
        def decode(2) do
          :RESPONSE
        end,
        def decode(3) do
          :ERROR
        end
      ]

      def decode(x) do
        x
      end

      @spec constants() :: [{integer(), atom()}]
      def constants() do
        [{0, :UNKNOWN}, {1, :REQUEST}, {2, :RESPONSE}, {3, :ERROR}]
      end

      @spec has_constant?(any()) :: boolean()
      (
        [
          def has_constant?(:UNKNOWN) do
            true
          end,
          def has_constant?(:REQUEST) do
            true
          end,
          def has_constant?(:RESPONSE) do
            true
          end,
          def has_constant?(:ERROR) do
            true
          end
        ]

        def has_constant?(_) do
          false
        end
      )
    )
  end,
  defmodule SimpleWS.Proto.LoginProvider do
    @moduledoc false
    (
      defstruct []

      (
        @spec default() :: :UNKNOWN
        def default() do
          :UNKNOWN
        end
      )

      @spec encode(atom() | String.t()) :: integer() | atom()
      [
        (
          def encode(:UNKNOWN) do
            0
          end

          def encode("UNKNOWN") do
            0
          end
        ),
        (
          def encode(:GOOGLE) do
            1
          end

          def encode("GOOGLE") do
            1
          end
        ),
        (
          def encode(:APPLE) do
            2
          end

          def encode("APPLE") do
            2
          end
        ),
        (
          def encode(:CUSTOM) do
            3
          end

          def encode("CUSTOM") do
            3
          end
        )
      ]

      def encode(x) do
        x
      end

      @spec decode(integer()) :: atom() | integer()
      [
        def decode(0) do
          :UNKNOWN
        end,
        def decode(1) do
          :GOOGLE
        end,
        def decode(2) do
          :APPLE
        end,
        def decode(3) do
          :CUSTOM
        end
      ]

      def decode(x) do
        x
      end

      @spec constants() :: [{integer(), atom()}]
      def constants() do
        [{0, :UNKNOWN}, {1, :GOOGLE}, {2, :APPLE}, {3, :CUSTOM}]
      end

      @spec has_constant?(any()) :: boolean()
      (
        [
          def has_constant?(:UNKNOWN) do
            true
          end,
          def has_constant?(:GOOGLE) do
            true
          end,
          def has_constant?(:APPLE) do
            true
          end,
          def has_constant?(:CUSTOM) do
            true
          end
        ]

        def has_constant?(_) do
          false
        end
      )
    )
  end,
  defmodule SimpleWS.Proto.Echo do
    @moduledoc false
    defstruct message: "", __uf__: []

    (
      (
        @spec encode(struct) :: {:ok, iodata} | {:error, any}
        def encode(msg) do
          try do
            {:ok, encode!(msg)}
          rescue
            e in [Protox.EncodingError, Protox.RequiredFieldsError] -> {:error, e}
          end
        end

        @spec encode!(struct) :: iodata | no_return
        def encode!(msg) do
          [] |> encode_message(msg) |> encode_unknown_fields(msg)
        end
      )

      []

      [
        defp encode_message(acc, msg) do
          try do
            if msg.message == "" do
              acc
            else
              [acc, "\n", Protox.Encode.encode_string(msg.message)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:message, "invalid field value"), __STACKTRACE__
          end
        end
      ]

      defp encode_unknown_fields(acc, msg) do
        Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
          case wire_type do
            0 ->
              [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

            1 ->
              [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

            2 ->
              len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
              [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

            5 ->
              [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
          end
        end)
      end
    )

    (
      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def decode(bytes) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e in [Protox.DecodingError, Protox.IllegalTagError, Protox.RequiredFieldsError] ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def decode!(bytes) do
            parse_key_value(bytes, struct(SimpleWS.Proto.Echo))
          end
        )
      )

      (
        @spec parse_key_value(binary, struct) :: struct
        defp parse_key_value(<<>>, msg) do
          msg
        end

        defp parse_key_value(bytes, msg) do
          {field, rest} =
            case Protox.Decode.parse_key(bytes) do
              {0, _, _} ->
                raise %Protox.IllegalTagError{}

              {1, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)
                {[message: Protox.Decode.validate_string(delimited)], rest}

              {tag, wire_type, rest} ->
                {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                {[
                   {msg.__struct__.unknown_fields_name(),
                    [value | msg.__struct__.unknown_fields(msg)]}
                 ], rest}
            end

          msg_updated = struct(msg, field)
          parse_key_value(rest, msg_updated)
        end
      )

      []
    )

    (
      @spec json_decode(iodata(), keyword()) :: {:ok, struct()} | {:error, any()}
      def json_decode(input, opts \\ []) do
        try do
          {:ok, json_decode!(input, opts)}
        rescue
          e in Protox.JsonDecodingError -> {:error, e}
        end
      end

      @spec json_decode!(iodata(), keyword()) :: struct() | no_return()
      def json_decode!(input, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :decode)

        Protox.JsonDecode.decode!(
          input,
          SimpleWS.Proto.Echo,
          &json_library_wrapper.decode!(json_library, &1)
        )
      end

      @spec json_encode(struct(), keyword()) :: {:ok, iodata()} | {:error, any()}
      def json_encode(msg, opts \\ []) do
        try do
          {:ok, json_encode!(msg, opts)}
        rescue
          e in Protox.JsonEncodingError -> {:error, e}
        end
      end

      @spec json_encode!(struct(), keyword()) :: iodata() | no_return()
      def json_encode!(msg, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :encode)
        Protox.JsonEncode.encode!(msg, &json_library_wrapper.encode!(json_library, &1))
      end
    )

    (
      @deprecated "Use fields_defs()/0 instead"
      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs() do
        %{1 => {:message, {:scalar, ""}, :string}}
      end

      @deprecated "Use fields_defs()/0 instead"
      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs_by_name() do
        %{message: {1, {:scalar, ""}, :string}}
      end
    )

    (
      @spec fields_defs() :: list(Protox.Field.t())
      def fields_defs() do
        [
          %{
            __struct__: Protox.Field,
            json_name: "message",
            kind: {:scalar, ""},
            label: :optional,
            name: :message,
            tag: 1,
            type: :string
          }
        ]
      end

      [
        @spec(field_def(atom) :: {:ok, Protox.Field.t()} | {:error, :no_such_field}),
        (
          def field_def(:message) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "message",
               kind: {:scalar, ""},
               label: :optional,
               name: :message,
               tag: 1,
               type: :string
             }}
          end

          def field_def("message") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "message",
               kind: {:scalar, ""},
               label: :optional,
               name: :message,
               tag: 1,
               type: :string
             }}
          end

          []
        ),
        def field_def(_) do
          {:error, :no_such_field}
        end
      ]
    )

    (
      @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
      def unknown_fields(msg) do
        msg.__uf__
      end

      @spec unknown_fields_name() :: :__uf__
      def unknown_fields_name() do
        :__uf__
      end

      @spec clear_unknown_fields(struct) :: struct
      def clear_unknown_fields(msg) do
        struct!(msg, [{unknown_fields_name(), []}])
      end
    )

    (
      @spec required_fields() :: []
      def required_fields() do
        []
      end
    )

    (
      @spec syntax() :: atom()
      def syntax() do
        :proto3
      end
    )

    [
      @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
      def default(:message) do
        {:ok, ""}
      end,
      def default(_) do
        {:error, :no_such_field}
      end
    ]

    (
      @spec file_options() :: nil
      def file_options() do
        nil
      end
    )
  end,
  defmodule SimpleWS.Proto.Envelope do
    @moduledoc false
    defstruct message_id: "", timestamp: 0, counter: 0, type: :UNKNOWN, payload: nil, __uf__: []

    (
      (
        @spec encode(struct) :: {:ok, iodata} | {:error, any}
        def encode(msg) do
          try do
            {:ok, encode!(msg)}
          rescue
            e in [Protox.EncodingError, Protox.RequiredFieldsError] -> {:error, e}
          end
        end

        @spec encode!(struct) :: iodata | no_return
        def encode!(msg) do
          []
          |> encode_payload(msg)
          |> encode_message_id(msg)
          |> encode_timestamp(msg)
          |> encode_counter(msg)
          |> encode_type(msg)
          |> encode_unknown_fields(msg)
        end
      )

      [
        defp encode_payload(acc, msg) do
          case msg.payload do
            nil -> acc
            {:request, _field_value} -> encode_request(acc, msg)
            {:response, _field_value} -> encode_response(acc, msg)
            {:error, _field_value} -> encode_error(acc, msg)
          end
        end
      ]

      [
        defp encode_message_id(acc, msg) do
          try do
            if msg.message_id == "" do
              acc
            else
              [acc, "\n", Protox.Encode.encode_string(msg.message_id)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:message_id, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_timestamp(acc, msg) do
          try do
            if msg.timestamp == 0 do
              acc
            else
              [acc, "\x10", Protox.Encode.encode_int64(msg.timestamp)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:timestamp, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_counter(acc, msg) do
          try do
            if msg.counter == 0 do
              acc
            else
              [acc, "\x18", Protox.Encode.encode_uint64(msg.counter)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:counter, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_type(acc, msg) do
          try do
            if msg.type == :UNKNOWN do
              acc
            else
              [
                acc,
                " ",
                msg.type
                |> SimpleWS.Proto.Envelope.ContentType.encode()
                |> Protox.Encode.encode_enum()
              ]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:type, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_request(acc, msg) do
          try do
            {_, child_field_value} = msg.payload
            [acc, "*", Protox.Encode.encode_message(child_field_value)]
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:request, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_response(acc, msg) do
          try do
            {_, child_field_value} = msg.payload
            [acc, "2", Protox.Encode.encode_message(child_field_value)]
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:response, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_error(acc, msg) do
          try do
            {_, child_field_value} = msg.payload
            [acc, ":", Protox.Encode.encode_message(child_field_value)]
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:error, "invalid field value"), __STACKTRACE__
          end
        end
      ]

      defp encode_unknown_fields(acc, msg) do
        Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
          case wire_type do
            0 ->
              [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

            1 ->
              [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

            2 ->
              len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
              [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

            5 ->
              [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
          end
        end)
      end
    )

    (
      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def decode(bytes) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e in [Protox.DecodingError, Protox.IllegalTagError, Protox.RequiredFieldsError] ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def decode!(bytes) do
            parse_key_value(bytes, struct(SimpleWS.Proto.Envelope))
          end
        )
      )

      (
        @spec parse_key_value(binary, struct) :: struct
        defp parse_key_value(<<>>, msg) do
          msg
        end

        defp parse_key_value(bytes, msg) do
          {field, rest} =
            case Protox.Decode.parse_key(bytes) do
              {0, _, _} ->
                raise %Protox.IllegalTagError{}

              {1, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)
                {[message_id: Protox.Decode.validate_string(delimited)], rest}

              {2, _, bytes} ->
                {value, rest} = Protox.Decode.parse_int64(bytes)
                {[timestamp: value], rest}

              {3, _, bytes} ->
                {value, rest} = Protox.Decode.parse_uint64(bytes)
                {[counter: value], rest}

              {4, _, bytes} ->
                {value, rest} =
                  Protox.Decode.parse_enum(bytes, SimpleWS.Proto.Envelope.ContentType)

                {[type: value], rest}

              {5, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   case msg.payload do
                     {:request, previous_value} ->
                       {:payload,
                        {:request,
                         Protox.MergeMessage.merge(
                           previous_value,
                           SimpleWS.Proto.Request.decode!(delimited)
                         )}}

                     _ ->
                       {:payload, {:request, SimpleWS.Proto.Request.decode!(delimited)}}
                   end
                 ], rest}

              {6, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   case msg.payload do
                     {:response, previous_value} ->
                       {:payload,
                        {:response,
                         Protox.MergeMessage.merge(
                           previous_value,
                           SimpleWS.Proto.Response.decode!(delimited)
                         )}}

                     _ ->
                       {:payload, {:response, SimpleWS.Proto.Response.decode!(delimited)}}
                   end
                 ], rest}

              {7, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   case msg.payload do
                     {:error, previous_value} ->
                       {:payload,
                        {:error,
                         Protox.MergeMessage.merge(
                           previous_value,
                           SimpleWS.Proto.Error.decode!(delimited)
                         )}}

                     _ ->
                       {:payload, {:error, SimpleWS.Proto.Error.decode!(delimited)}}
                   end
                 ], rest}

              {tag, wire_type, rest} ->
                {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                {[
                   {msg.__struct__.unknown_fields_name(),
                    [value | msg.__struct__.unknown_fields(msg)]}
                 ], rest}
            end

          msg_updated = struct(msg, field)
          parse_key_value(rest, msg_updated)
        end
      )

      []
    )

    (
      @spec json_decode(iodata(), keyword()) :: {:ok, struct()} | {:error, any()}
      def json_decode(input, opts \\ []) do
        try do
          {:ok, json_decode!(input, opts)}
        rescue
          e in Protox.JsonDecodingError -> {:error, e}
        end
      end

      @spec json_decode!(iodata(), keyword()) :: struct() | no_return()
      def json_decode!(input, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :decode)

        Protox.JsonDecode.decode!(
          input,
          SimpleWS.Proto.Envelope,
          &json_library_wrapper.decode!(json_library, &1)
        )
      end

      @spec json_encode(struct(), keyword()) :: {:ok, iodata()} | {:error, any()}
      def json_encode(msg, opts \\ []) do
        try do
          {:ok, json_encode!(msg, opts)}
        rescue
          e in Protox.JsonEncodingError -> {:error, e}
        end
      end

      @spec json_encode!(struct(), keyword()) :: iodata() | no_return()
      def json_encode!(msg, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :encode)
        Protox.JsonEncode.encode!(msg, &json_library_wrapper.encode!(json_library, &1))
      end
    )

    (
      @deprecated "Use fields_defs()/0 instead"
      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs() do
        %{
          1 => {:message_id, {:scalar, ""}, :string},
          2 => {:timestamp, {:scalar, 0}, :int64},
          3 => {:counter, {:scalar, 0}, :uint64},
          4 => {:type, {:scalar, :UNKNOWN}, {:enum, SimpleWS.Proto.Envelope.ContentType}},
          5 => {:request, {:oneof, :payload}, {:message, SimpleWS.Proto.Request}},
          6 => {:response, {:oneof, :payload}, {:message, SimpleWS.Proto.Response}},
          7 => {:error, {:oneof, :payload}, {:message, SimpleWS.Proto.Error}}
        }
      end

      @deprecated "Use fields_defs()/0 instead"
      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs_by_name() do
        %{
          counter: {3, {:scalar, 0}, :uint64},
          error: {7, {:oneof, :payload}, {:message, SimpleWS.Proto.Error}},
          message_id: {1, {:scalar, ""}, :string},
          request: {5, {:oneof, :payload}, {:message, SimpleWS.Proto.Request}},
          response: {6, {:oneof, :payload}, {:message, SimpleWS.Proto.Response}},
          timestamp: {2, {:scalar, 0}, :int64},
          type: {4, {:scalar, :UNKNOWN}, {:enum, SimpleWS.Proto.Envelope.ContentType}}
        }
      end
    )

    (
      @spec fields_defs() :: list(Protox.Field.t())
      def fields_defs() do
        [
          %{
            __struct__: Protox.Field,
            json_name: "messageId",
            kind: {:scalar, ""},
            label: :optional,
            name: :message_id,
            tag: 1,
            type: :string
          },
          %{
            __struct__: Protox.Field,
            json_name: "timestamp",
            kind: {:scalar, 0},
            label: :optional,
            name: :timestamp,
            tag: 2,
            type: :int64
          },
          %{
            __struct__: Protox.Field,
            json_name: "counter",
            kind: {:scalar, 0},
            label: :optional,
            name: :counter,
            tag: 3,
            type: :uint64
          },
          %{
            __struct__: Protox.Field,
            json_name: "type",
            kind: {:scalar, :UNKNOWN},
            label: :optional,
            name: :type,
            tag: 4,
            type: {:enum, SimpleWS.Proto.Envelope.ContentType}
          },
          %{
            __struct__: Protox.Field,
            json_name: "request",
            kind: {:oneof, :payload},
            label: :optional,
            name: :request,
            tag: 5,
            type: {:message, SimpleWS.Proto.Request}
          },
          %{
            __struct__: Protox.Field,
            json_name: "response",
            kind: {:oneof, :payload},
            label: :optional,
            name: :response,
            tag: 6,
            type: {:message, SimpleWS.Proto.Response}
          },
          %{
            __struct__: Protox.Field,
            json_name: "error",
            kind: {:oneof, :payload},
            label: :optional,
            name: :error,
            tag: 7,
            type: {:message, SimpleWS.Proto.Error}
          }
        ]
      end

      [
        @spec(field_def(atom) :: {:ok, Protox.Field.t()} | {:error, :no_such_field}),
        (
          def field_def(:message_id) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "messageId",
               kind: {:scalar, ""},
               label: :optional,
               name: :message_id,
               tag: 1,
               type: :string
             }}
          end

          def field_def("messageId") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "messageId",
               kind: {:scalar, ""},
               label: :optional,
               name: :message_id,
               tag: 1,
               type: :string
             }}
          end

          def field_def("message_id") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "messageId",
               kind: {:scalar, ""},
               label: :optional,
               name: :message_id,
               tag: 1,
               type: :string
             }}
          end
        ),
        (
          def field_def(:timestamp) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "timestamp",
               kind: {:scalar, 0},
               label: :optional,
               name: :timestamp,
               tag: 2,
               type: :int64
             }}
          end

          def field_def("timestamp") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "timestamp",
               kind: {:scalar, 0},
               label: :optional,
               name: :timestamp,
               tag: 2,
               type: :int64
             }}
          end

          []
        ),
        (
          def field_def(:counter) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "counter",
               kind: {:scalar, 0},
               label: :optional,
               name: :counter,
               tag: 3,
               type: :uint64
             }}
          end

          def field_def("counter") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "counter",
               kind: {:scalar, 0},
               label: :optional,
               name: :counter,
               tag: 3,
               type: :uint64
             }}
          end

          []
        ),
        (
          def field_def(:type) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "type",
               kind: {:scalar, :UNKNOWN},
               label: :optional,
               name: :type,
               tag: 4,
               type: {:enum, SimpleWS.Proto.Envelope.ContentType}
             }}
          end

          def field_def("type") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "type",
               kind: {:scalar, :UNKNOWN},
               label: :optional,
               name: :type,
               tag: 4,
               type: {:enum, SimpleWS.Proto.Envelope.ContentType}
             }}
          end

          []
        ),
        (
          def field_def(:request) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "request",
               kind: {:oneof, :payload},
               label: :optional,
               name: :request,
               tag: 5,
               type: {:message, SimpleWS.Proto.Request}
             }}
          end

          def field_def("request") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "request",
               kind: {:oneof, :payload},
               label: :optional,
               name: :request,
               tag: 5,
               type: {:message, SimpleWS.Proto.Request}
             }}
          end

          []
        ),
        (
          def field_def(:response) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "response",
               kind: {:oneof, :payload},
               label: :optional,
               name: :response,
               tag: 6,
               type: {:message, SimpleWS.Proto.Response}
             }}
          end

          def field_def("response") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "response",
               kind: {:oneof, :payload},
               label: :optional,
               name: :response,
               tag: 6,
               type: {:message, SimpleWS.Proto.Response}
             }}
          end

          []
        ),
        (
          def field_def(:error) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "error",
               kind: {:oneof, :payload},
               label: :optional,
               name: :error,
               tag: 7,
               type: {:message, SimpleWS.Proto.Error}
             }}
          end

          def field_def("error") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "error",
               kind: {:oneof, :payload},
               label: :optional,
               name: :error,
               tag: 7,
               type: {:message, SimpleWS.Proto.Error}
             }}
          end

          []
        ),
        def field_def(_) do
          {:error, :no_such_field}
        end
      ]
    )

    (
      @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
      def unknown_fields(msg) do
        msg.__uf__
      end

      @spec unknown_fields_name() :: :__uf__
      def unknown_fields_name() do
        :__uf__
      end

      @spec clear_unknown_fields(struct) :: struct
      def clear_unknown_fields(msg) do
        struct!(msg, [{unknown_fields_name(), []}])
      end
    )

    (
      @spec required_fields() :: []
      def required_fields() do
        []
      end
    )

    (
      @spec syntax() :: atom()
      def syntax() do
        :proto3
      end
    )

    [
      @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
      def default(:message_id) do
        {:ok, ""}
      end,
      def default(:timestamp) do
        {:ok, 0}
      end,
      def default(:counter) do
        {:ok, 0}
      end,
      def default(:type) do
        {:ok, :UNKNOWN}
      end,
      def default(:request) do
        {:error, :no_default_value}
      end,
      def default(:response) do
        {:error, :no_default_value}
      end,
      def default(:error) do
        {:error, :no_default_value}
      end,
      def default(_) do
        {:error, :no_such_field}
      end
    ]

    (
      @spec file_options() :: nil
      def file_options() do
        nil
      end
    )
  end,
  defmodule SimpleWS.Proto.Error do
    @moduledoc false
    defstruct request_id: "", code: "", message: "", __uf__: []

    (
      (
        @spec encode(struct) :: {:ok, iodata} | {:error, any}
        def encode(msg) do
          try do
            {:ok, encode!(msg)}
          rescue
            e in [Protox.EncodingError, Protox.RequiredFieldsError] -> {:error, e}
          end
        end

        @spec encode!(struct) :: iodata | no_return
        def encode!(msg) do
          []
          |> encode_request_id(msg)
          |> encode_code(msg)
          |> encode_message(msg)
          |> encode_unknown_fields(msg)
        end
      )

      []

      [
        defp encode_request_id(acc, msg) do
          try do
            if msg.request_id == "" do
              acc
            else
              [acc, "\n", Protox.Encode.encode_string(msg.request_id)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:request_id, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_code(acc, msg) do
          try do
            if msg.code == "" do
              acc
            else
              [acc, "\x12", Protox.Encode.encode_string(msg.code)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:code, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_message(acc, msg) do
          try do
            if msg.message == "" do
              acc
            else
              [acc, "\x1A", Protox.Encode.encode_string(msg.message)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:message, "invalid field value"), __STACKTRACE__
          end
        end
      ]

      defp encode_unknown_fields(acc, msg) do
        Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
          case wire_type do
            0 ->
              [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

            1 ->
              [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

            2 ->
              len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
              [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

            5 ->
              [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
          end
        end)
      end
    )

    (
      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def decode(bytes) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e in [Protox.DecodingError, Protox.IllegalTagError, Protox.RequiredFieldsError] ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def decode!(bytes) do
            parse_key_value(bytes, struct(SimpleWS.Proto.Error))
          end
        )
      )

      (
        @spec parse_key_value(binary, struct) :: struct
        defp parse_key_value(<<>>, msg) do
          msg
        end

        defp parse_key_value(bytes, msg) do
          {field, rest} =
            case Protox.Decode.parse_key(bytes) do
              {0, _, _} ->
                raise %Protox.IllegalTagError{}

              {1, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)
                {[request_id: Protox.Decode.validate_string(delimited)], rest}

              {2, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)
                {[code: Protox.Decode.validate_string(delimited)], rest}

              {3, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)
                {[message: Protox.Decode.validate_string(delimited)], rest}

              {tag, wire_type, rest} ->
                {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                {[
                   {msg.__struct__.unknown_fields_name(),
                    [value | msg.__struct__.unknown_fields(msg)]}
                 ], rest}
            end

          msg_updated = struct(msg, field)
          parse_key_value(rest, msg_updated)
        end
      )

      []
    )

    (
      @spec json_decode(iodata(), keyword()) :: {:ok, struct()} | {:error, any()}
      def json_decode(input, opts \\ []) do
        try do
          {:ok, json_decode!(input, opts)}
        rescue
          e in Protox.JsonDecodingError -> {:error, e}
        end
      end

      @spec json_decode!(iodata(), keyword()) :: struct() | no_return()
      def json_decode!(input, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :decode)

        Protox.JsonDecode.decode!(
          input,
          SimpleWS.Proto.Error,
          &json_library_wrapper.decode!(json_library, &1)
        )
      end

      @spec json_encode(struct(), keyword()) :: {:ok, iodata()} | {:error, any()}
      def json_encode(msg, opts \\ []) do
        try do
          {:ok, json_encode!(msg, opts)}
        rescue
          e in Protox.JsonEncodingError -> {:error, e}
        end
      end

      @spec json_encode!(struct(), keyword()) :: iodata() | no_return()
      def json_encode!(msg, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :encode)
        Protox.JsonEncode.encode!(msg, &json_library_wrapper.encode!(json_library, &1))
      end
    )

    (
      @deprecated "Use fields_defs()/0 instead"
      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs() do
        %{
          1 => {:request_id, {:scalar, ""}, :string},
          2 => {:code, {:scalar, ""}, :string},
          3 => {:message, {:scalar, ""}, :string}
        }
      end

      @deprecated "Use fields_defs()/0 instead"
      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs_by_name() do
        %{
          code: {2, {:scalar, ""}, :string},
          message: {3, {:scalar, ""}, :string},
          request_id: {1, {:scalar, ""}, :string}
        }
      end
    )

    (
      @spec fields_defs() :: list(Protox.Field.t())
      def fields_defs() do
        [
          %{
            __struct__: Protox.Field,
            json_name: "requestId",
            kind: {:scalar, ""},
            label: :optional,
            name: :request_id,
            tag: 1,
            type: :string
          },
          %{
            __struct__: Protox.Field,
            json_name: "code",
            kind: {:scalar, ""},
            label: :optional,
            name: :code,
            tag: 2,
            type: :string
          },
          %{
            __struct__: Protox.Field,
            json_name: "message",
            kind: {:scalar, ""},
            label: :optional,
            name: :message,
            tag: 3,
            type: :string
          }
        ]
      end

      [
        @spec(field_def(atom) :: {:ok, Protox.Field.t()} | {:error, :no_such_field}),
        (
          def field_def(:request_id) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "requestId",
               kind: {:scalar, ""},
               label: :optional,
               name: :request_id,
               tag: 1,
               type: :string
             }}
          end

          def field_def("requestId") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "requestId",
               kind: {:scalar, ""},
               label: :optional,
               name: :request_id,
               tag: 1,
               type: :string
             }}
          end

          def field_def("request_id") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "requestId",
               kind: {:scalar, ""},
               label: :optional,
               name: :request_id,
               tag: 1,
               type: :string
             }}
          end
        ),
        (
          def field_def(:code) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "code",
               kind: {:scalar, ""},
               label: :optional,
               name: :code,
               tag: 2,
               type: :string
             }}
          end

          def field_def("code") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "code",
               kind: {:scalar, ""},
               label: :optional,
               name: :code,
               tag: 2,
               type: :string
             }}
          end

          []
        ),
        (
          def field_def(:message) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "message",
               kind: {:scalar, ""},
               label: :optional,
               name: :message,
               tag: 3,
               type: :string
             }}
          end

          def field_def("message") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "message",
               kind: {:scalar, ""},
               label: :optional,
               name: :message,
               tag: 3,
               type: :string
             }}
          end

          []
        ),
        def field_def(_) do
          {:error, :no_such_field}
        end
      ]
    )

    (
      @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
      def unknown_fields(msg) do
        msg.__uf__
      end

      @spec unknown_fields_name() :: :__uf__
      def unknown_fields_name() do
        :__uf__
      end

      @spec clear_unknown_fields(struct) :: struct
      def clear_unknown_fields(msg) do
        struct!(msg, [{unknown_fields_name(), []}])
      end
    )

    (
      @spec required_fields() :: []
      def required_fields() do
        []
      end
    )

    (
      @spec syntax() :: atom()
      def syntax() do
        :proto3
      end
    )

    [
      @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
      def default(:request_id) do
        {:ok, ""}
      end,
      def default(:code) do
        {:ok, ""}
      end,
      def default(:message) do
        {:ok, ""}
      end,
      def default(_) do
        {:error, :no_such_field}
      end
    ]

    (
      @spec file_options() :: nil
      def file_options() do
        nil
      end
    )
  end,
  defmodule SimpleWS.Proto.LoginRequest do
    @moduledoc false
    defstruct provider: :UNKNOWN, credentials: %{}, __uf__: []

    (
      (
        @spec encode(struct) :: {:ok, iodata} | {:error, any}
        def encode(msg) do
          try do
            {:ok, encode!(msg)}
          rescue
            e in [Protox.EncodingError, Protox.RequiredFieldsError] -> {:error, e}
          end
        end

        @spec encode!(struct) :: iodata | no_return
        def encode!(msg) do
          [] |> encode_provider(msg) |> encode_credentials(msg) |> encode_unknown_fields(msg)
        end
      )

      []

      [
        defp encode_provider(acc, msg) do
          try do
            if msg.provider == :UNKNOWN do
              acc
            else
              [
                acc,
                "\b",
                msg.provider
                |> SimpleWS.Proto.LoginProvider.encode()
                |> Protox.Encode.encode_enum()
              ]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:provider, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_credentials(acc, msg) do
          try do
            map = Map.fetch!(msg, :credentials)

            Enum.reduce(map, acc, fn {k, v}, acc ->
              map_key_value_bytes = :binary.list_to_bin([Protox.Encode.encode_string(k)])
              map_key_value_len = byte_size(map_key_value_bytes)
              map_value_value_bytes = :binary.list_to_bin([Protox.Encode.encode_string(v)])
              map_value_value_len = byte_size(map_value_value_bytes)
              len = Protox.Varint.encode(2 + map_key_value_len + map_value_value_len)
              [acc, "\x12", len, "\n", map_key_value_bytes, "\x12", map_value_value_bytes]
            end)
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:credentials, "invalid field value"),
                      __STACKTRACE__
          end
        end
      ]

      defp encode_unknown_fields(acc, msg) do
        Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
          case wire_type do
            0 ->
              [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

            1 ->
              [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

            2 ->
              len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
              [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

            5 ->
              [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
          end
        end)
      end
    )

    (
      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def decode(bytes) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e in [Protox.DecodingError, Protox.IllegalTagError, Protox.RequiredFieldsError] ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def decode!(bytes) do
            parse_key_value(bytes, struct(SimpleWS.Proto.LoginRequest))
          end
        )
      )

      (
        @spec parse_key_value(binary, struct) :: struct
        defp parse_key_value(<<>>, msg) do
          msg
        end

        defp parse_key_value(bytes, msg) do
          {field, rest} =
            case Protox.Decode.parse_key(bytes) do
              {0, _, _} ->
                raise %Protox.IllegalTagError{}

              {1, _, bytes} ->
                {value, rest} = Protox.Decode.parse_enum(bytes, SimpleWS.Proto.LoginProvider)
                {[provider: value], rest}

              {2, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   (
                     {entry_key, entry_value} =
                       (
                         {map_key, map_value} = parse_string_string({:unset, :unset}, delimited)

                         map_key =
                           case map_key do
                             :unset -> Protox.Default.default(:string)
                             _ -> map_key
                           end

                         map_value =
                           case map_value do
                             :unset -> Protox.Default.default(:string)
                             _ -> map_value
                           end

                         {map_key, map_value}
                       )

                     {:credentials, Map.put(msg.credentials, entry_key, entry_value)}
                   )
                 ], rest}

              {tag, wire_type, rest} ->
                {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                {[
                   {msg.__struct__.unknown_fields_name(),
                    [value | msg.__struct__.unknown_fields(msg)]}
                 ], rest}
            end

          msg_updated = struct(msg, field)
          parse_key_value(rest, msg_updated)
        end
      )

      [
        (
          defp parse_string_string(map_entry, <<>>) do
            map_entry
          end

          defp parse_string_string({entry_key, entry_value}, bytes) do
            {map_entry, rest} =
              case Protox.Decode.parse_key(bytes) do
                {1, _, rest} ->
                  {res, rest} =
                    (
                      {len, new_rest} = Protox.Varint.decode(rest)
                      {delimited, new_rest} = Protox.Decode.parse_delimited(new_rest, len)
                      {Protox.Decode.validate_string(delimited), new_rest}
                    )

                  {{res, entry_value}, rest}

                {2, _, rest} ->
                  {res, rest} =
                    (
                      {len, new_rest} = Protox.Varint.decode(rest)
                      {delimited, new_rest} = Protox.Decode.parse_delimited(new_rest, len)
                      {Protox.Decode.validate_string(delimited), new_rest}
                    )

                  {{entry_key, res}, rest}

                {tag, wire_type, rest} ->
                  {_, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)
                  {{entry_key, entry_value}, rest}
              end

            parse_string_string(map_entry, rest)
          end
        )
      ]
    )

    (
      @spec json_decode(iodata(), keyword()) :: {:ok, struct()} | {:error, any()}
      def json_decode(input, opts \\ []) do
        try do
          {:ok, json_decode!(input, opts)}
        rescue
          e in Protox.JsonDecodingError -> {:error, e}
        end
      end

      @spec json_decode!(iodata(), keyword()) :: struct() | no_return()
      def json_decode!(input, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :decode)

        Protox.JsonDecode.decode!(
          input,
          SimpleWS.Proto.LoginRequest,
          &json_library_wrapper.decode!(json_library, &1)
        )
      end

      @spec json_encode(struct(), keyword()) :: {:ok, iodata()} | {:error, any()}
      def json_encode(msg, opts \\ []) do
        try do
          {:ok, json_encode!(msg, opts)}
        rescue
          e in Protox.JsonEncodingError -> {:error, e}
        end
      end

      @spec json_encode!(struct(), keyword()) :: iodata() | no_return()
      def json_encode!(msg, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :encode)
        Protox.JsonEncode.encode!(msg, &json_library_wrapper.encode!(json_library, &1))
      end
    )

    (
      @deprecated "Use fields_defs()/0 instead"
      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs() do
        %{
          1 => {:provider, {:scalar, :UNKNOWN}, {:enum, SimpleWS.Proto.LoginProvider}},
          2 => {:credentials, :map, {:string, :string}}
        }
      end

      @deprecated "Use fields_defs()/0 instead"
      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs_by_name() do
        %{
          credentials: {2, :map, {:string, :string}},
          provider: {1, {:scalar, :UNKNOWN}, {:enum, SimpleWS.Proto.LoginProvider}}
        }
      end
    )

    (
      @spec fields_defs() :: list(Protox.Field.t())
      def fields_defs() do
        [
          %{
            __struct__: Protox.Field,
            json_name: "provider",
            kind: {:scalar, :UNKNOWN},
            label: :optional,
            name: :provider,
            tag: 1,
            type: {:enum, SimpleWS.Proto.LoginProvider}
          },
          %{
            __struct__: Protox.Field,
            json_name: "credentials",
            kind: :map,
            label: nil,
            name: :credentials,
            tag: 2,
            type: {:string, :string}
          }
        ]
      end

      [
        @spec(field_def(atom) :: {:ok, Protox.Field.t()} | {:error, :no_such_field}),
        (
          def field_def(:provider) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "provider",
               kind: {:scalar, :UNKNOWN},
               label: :optional,
               name: :provider,
               tag: 1,
               type: {:enum, SimpleWS.Proto.LoginProvider}
             }}
          end

          def field_def("provider") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "provider",
               kind: {:scalar, :UNKNOWN},
               label: :optional,
               name: :provider,
               tag: 1,
               type: {:enum, SimpleWS.Proto.LoginProvider}
             }}
          end

          []
        ),
        (
          def field_def(:credentials) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "credentials",
               kind: :map,
               label: nil,
               name: :credentials,
               tag: 2,
               type: {:string, :string}
             }}
          end

          def field_def("credentials") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "credentials",
               kind: :map,
               label: nil,
               name: :credentials,
               tag: 2,
               type: {:string, :string}
             }}
          end

          []
        ),
        def field_def(_) do
          {:error, :no_such_field}
        end
      ]
    )

    (
      @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
      def unknown_fields(msg) do
        msg.__uf__
      end

      @spec unknown_fields_name() :: :__uf__
      def unknown_fields_name() do
        :__uf__
      end

      @spec clear_unknown_fields(struct) :: struct
      def clear_unknown_fields(msg) do
        struct!(msg, [{unknown_fields_name(), []}])
      end
    )

    (
      @spec required_fields() :: []
      def required_fields() do
        []
      end
    )

    (
      @spec syntax() :: atom()
      def syntax() do
        :proto3
      end
    )

    [
      @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
      def default(:provider) do
        {:ok, :UNKNOWN}
      end,
      def default(:credentials) do
        {:error, :no_default_value}
      end,
      def default(_) do
        {:error, :no_such_field}
      end
    ]

    (
      @spec file_options() :: nil
      def file_options() do
        nil
      end
    )
  end,
  defmodule SimpleWS.Proto.LoginResponse do
    @moduledoc false
    defstruct provider: :UNKNOWN, tokens: %{}, __uf__: []

    (
      (
        @spec encode(struct) :: {:ok, iodata} | {:error, any}
        def encode(msg) do
          try do
            {:ok, encode!(msg)}
          rescue
            e in [Protox.EncodingError, Protox.RequiredFieldsError] -> {:error, e}
          end
        end

        @spec encode!(struct) :: iodata | no_return
        def encode!(msg) do
          [] |> encode_provider(msg) |> encode_tokens(msg) |> encode_unknown_fields(msg)
        end
      )

      []

      [
        defp encode_provider(acc, msg) do
          try do
            if msg.provider == :UNKNOWN do
              acc
            else
              [
                acc,
                "\b",
                msg.provider
                |> SimpleWS.Proto.LoginProvider.encode()
                |> Protox.Encode.encode_enum()
              ]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:provider, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_tokens(acc, msg) do
          try do
            map = Map.fetch!(msg, :tokens)

            Enum.reduce(map, acc, fn {k, v}, acc ->
              map_key_value_bytes = :binary.list_to_bin([Protox.Encode.encode_string(k)])
              map_key_value_len = byte_size(map_key_value_bytes)
              map_value_value_bytes = :binary.list_to_bin([Protox.Encode.encode_string(v)])
              map_value_value_len = byte_size(map_value_value_bytes)
              len = Protox.Varint.encode(2 + map_key_value_len + map_value_value_len)
              [acc, "\x12", len, "\n", map_key_value_bytes, "\x12", map_value_value_bytes]
            end)
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:tokens, "invalid field value"), __STACKTRACE__
          end
        end
      ]

      defp encode_unknown_fields(acc, msg) do
        Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
          case wire_type do
            0 ->
              [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

            1 ->
              [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

            2 ->
              len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
              [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

            5 ->
              [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
          end
        end)
      end
    )

    (
      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def decode(bytes) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e in [Protox.DecodingError, Protox.IllegalTagError, Protox.RequiredFieldsError] ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def decode!(bytes) do
            parse_key_value(bytes, struct(SimpleWS.Proto.LoginResponse))
          end
        )
      )

      (
        @spec parse_key_value(binary, struct) :: struct
        defp parse_key_value(<<>>, msg) do
          msg
        end

        defp parse_key_value(bytes, msg) do
          {field, rest} =
            case Protox.Decode.parse_key(bytes) do
              {0, _, _} ->
                raise %Protox.IllegalTagError{}

              {1, _, bytes} ->
                {value, rest} = Protox.Decode.parse_enum(bytes, SimpleWS.Proto.LoginProvider)
                {[provider: value], rest}

              {2, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   (
                     {entry_key, entry_value} =
                       (
                         {map_key, map_value} = parse_string_string({:unset, :unset}, delimited)

                         map_key =
                           case map_key do
                             :unset -> Protox.Default.default(:string)
                             _ -> map_key
                           end

                         map_value =
                           case map_value do
                             :unset -> Protox.Default.default(:string)
                             _ -> map_value
                           end

                         {map_key, map_value}
                       )

                     {:tokens, Map.put(msg.tokens, entry_key, entry_value)}
                   )
                 ], rest}

              {tag, wire_type, rest} ->
                {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                {[
                   {msg.__struct__.unknown_fields_name(),
                    [value | msg.__struct__.unknown_fields(msg)]}
                 ], rest}
            end

          msg_updated = struct(msg, field)
          parse_key_value(rest, msg_updated)
        end
      )

      [
        (
          defp parse_string_string(map_entry, <<>>) do
            map_entry
          end

          defp parse_string_string({entry_key, entry_value}, bytes) do
            {map_entry, rest} =
              case Protox.Decode.parse_key(bytes) do
                {1, _, rest} ->
                  {res, rest} =
                    (
                      {len, new_rest} = Protox.Varint.decode(rest)
                      {delimited, new_rest} = Protox.Decode.parse_delimited(new_rest, len)
                      {Protox.Decode.validate_string(delimited), new_rest}
                    )

                  {{res, entry_value}, rest}

                {2, _, rest} ->
                  {res, rest} =
                    (
                      {len, new_rest} = Protox.Varint.decode(rest)
                      {delimited, new_rest} = Protox.Decode.parse_delimited(new_rest, len)
                      {Protox.Decode.validate_string(delimited), new_rest}
                    )

                  {{entry_key, res}, rest}

                {tag, wire_type, rest} ->
                  {_, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)
                  {{entry_key, entry_value}, rest}
              end

            parse_string_string(map_entry, rest)
          end
        )
      ]
    )

    (
      @spec json_decode(iodata(), keyword()) :: {:ok, struct()} | {:error, any()}
      def json_decode(input, opts \\ []) do
        try do
          {:ok, json_decode!(input, opts)}
        rescue
          e in Protox.JsonDecodingError -> {:error, e}
        end
      end

      @spec json_decode!(iodata(), keyword()) :: struct() | no_return()
      def json_decode!(input, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :decode)

        Protox.JsonDecode.decode!(
          input,
          SimpleWS.Proto.LoginResponse,
          &json_library_wrapper.decode!(json_library, &1)
        )
      end

      @spec json_encode(struct(), keyword()) :: {:ok, iodata()} | {:error, any()}
      def json_encode(msg, opts \\ []) do
        try do
          {:ok, json_encode!(msg, opts)}
        rescue
          e in Protox.JsonEncodingError -> {:error, e}
        end
      end

      @spec json_encode!(struct(), keyword()) :: iodata() | no_return()
      def json_encode!(msg, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :encode)
        Protox.JsonEncode.encode!(msg, &json_library_wrapper.encode!(json_library, &1))
      end
    )

    (
      @deprecated "Use fields_defs()/0 instead"
      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs() do
        %{
          1 => {:provider, {:scalar, :UNKNOWN}, {:enum, SimpleWS.Proto.LoginProvider}},
          2 => {:tokens, :map, {:string, :string}}
        }
      end

      @deprecated "Use fields_defs()/0 instead"
      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs_by_name() do
        %{
          provider: {1, {:scalar, :UNKNOWN}, {:enum, SimpleWS.Proto.LoginProvider}},
          tokens: {2, :map, {:string, :string}}
        }
      end
    )

    (
      @spec fields_defs() :: list(Protox.Field.t())
      def fields_defs() do
        [
          %{
            __struct__: Protox.Field,
            json_name: "provider",
            kind: {:scalar, :UNKNOWN},
            label: :optional,
            name: :provider,
            tag: 1,
            type: {:enum, SimpleWS.Proto.LoginProvider}
          },
          %{
            __struct__: Protox.Field,
            json_name: "tokens",
            kind: :map,
            label: nil,
            name: :tokens,
            tag: 2,
            type: {:string, :string}
          }
        ]
      end

      [
        @spec(field_def(atom) :: {:ok, Protox.Field.t()} | {:error, :no_such_field}),
        (
          def field_def(:provider) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "provider",
               kind: {:scalar, :UNKNOWN},
               label: :optional,
               name: :provider,
               tag: 1,
               type: {:enum, SimpleWS.Proto.LoginProvider}
             }}
          end

          def field_def("provider") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "provider",
               kind: {:scalar, :UNKNOWN},
               label: :optional,
               name: :provider,
               tag: 1,
               type: {:enum, SimpleWS.Proto.LoginProvider}
             }}
          end

          []
        ),
        (
          def field_def(:tokens) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "tokens",
               kind: :map,
               label: nil,
               name: :tokens,
               tag: 2,
               type: {:string, :string}
             }}
          end

          def field_def("tokens") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "tokens",
               kind: :map,
               label: nil,
               name: :tokens,
               tag: 2,
               type: {:string, :string}
             }}
          end

          []
        ),
        def field_def(_) do
          {:error, :no_such_field}
        end
      ]
    )

    (
      @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
      def unknown_fields(msg) do
        msg.__uf__
      end

      @spec unknown_fields_name() :: :__uf__
      def unknown_fields_name() do
        :__uf__
      end

      @spec clear_unknown_fields(struct) :: struct
      def clear_unknown_fields(msg) do
        struct!(msg, [{unknown_fields_name(), []}])
      end
    )

    (
      @spec required_fields() :: []
      def required_fields() do
        []
      end
    )

    (
      @spec syntax() :: atom()
      def syntax() do
        :proto3
      end
    )

    [
      @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
      def default(:provider) do
        {:ok, :UNKNOWN}
      end,
      def default(:tokens) do
        {:error, :no_default_value}
      end,
      def default(_) do
        {:error, :no_such_field}
      end
    ]

    (
      @spec file_options() :: nil
      def file_options() do
        nil
      end
    )
  end,
  defmodule SimpleWS.Proto.Request do
    @moduledoc false
    defstruct payload: nil, __uf__: []

    (
      (
        @spec encode(struct) :: {:ok, iodata} | {:error, any}
        def encode(msg) do
          try do
            {:ok, encode!(msg)}
          rescue
            e in [Protox.EncodingError, Protox.RequiredFieldsError] -> {:error, e}
          end
        end

        @spec encode!(struct) :: iodata | no_return
        def encode!(msg) do
          [] |> encode_payload(msg) |> encode_unknown_fields(msg)
        end
      )

      [
        defp encode_payload(acc, msg) do
          case msg.payload do
            nil -> acc
            {:echo, _field_value} -> encode_echo(acc, msg)
            {:login, _field_value} -> encode_login(acc, msg)
          end
        end
      ]

      [
        defp encode_echo(acc, msg) do
          try do
            {_, child_field_value} = msg.payload
            [acc, "\n", Protox.Encode.encode_message(child_field_value)]
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:echo, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_login(acc, msg) do
          try do
            {_, child_field_value} = msg.payload
            [acc, "\x12", Protox.Encode.encode_message(child_field_value)]
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:login, "invalid field value"), __STACKTRACE__
          end
        end
      ]

      defp encode_unknown_fields(acc, msg) do
        Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
          case wire_type do
            0 ->
              [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

            1 ->
              [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

            2 ->
              len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
              [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

            5 ->
              [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
          end
        end)
      end
    )

    (
      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def decode(bytes) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e in [Protox.DecodingError, Protox.IllegalTagError, Protox.RequiredFieldsError] ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def decode!(bytes) do
            parse_key_value(bytes, struct(SimpleWS.Proto.Request))
          end
        )
      )

      (
        @spec parse_key_value(binary, struct) :: struct
        defp parse_key_value(<<>>, msg) do
          msg
        end

        defp parse_key_value(bytes, msg) do
          {field, rest} =
            case Protox.Decode.parse_key(bytes) do
              {0, _, _} ->
                raise %Protox.IllegalTagError{}

              {1, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   case msg.payload do
                     {:echo, previous_value} ->
                       {:payload,
                        {:echo,
                         Protox.MergeMessage.merge(
                           previous_value,
                           SimpleWS.Proto.Echo.decode!(delimited)
                         )}}

                     _ ->
                       {:payload, {:echo, SimpleWS.Proto.Echo.decode!(delimited)}}
                   end
                 ], rest}

              {2, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   case msg.payload do
                     {:login, previous_value} ->
                       {:payload,
                        {:login,
                         Protox.MergeMessage.merge(
                           previous_value,
                           SimpleWS.Proto.LoginRequest.decode!(delimited)
                         )}}

                     _ ->
                       {:payload, {:login, SimpleWS.Proto.LoginRequest.decode!(delimited)}}
                   end
                 ], rest}

              {tag, wire_type, rest} ->
                {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                {[
                   {msg.__struct__.unknown_fields_name(),
                    [value | msg.__struct__.unknown_fields(msg)]}
                 ], rest}
            end

          msg_updated = struct(msg, field)
          parse_key_value(rest, msg_updated)
        end
      )

      []
    )

    (
      @spec json_decode(iodata(), keyword()) :: {:ok, struct()} | {:error, any()}
      def json_decode(input, opts \\ []) do
        try do
          {:ok, json_decode!(input, opts)}
        rescue
          e in Protox.JsonDecodingError -> {:error, e}
        end
      end

      @spec json_decode!(iodata(), keyword()) :: struct() | no_return()
      def json_decode!(input, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :decode)

        Protox.JsonDecode.decode!(
          input,
          SimpleWS.Proto.Request,
          &json_library_wrapper.decode!(json_library, &1)
        )
      end

      @spec json_encode(struct(), keyword()) :: {:ok, iodata()} | {:error, any()}
      def json_encode(msg, opts \\ []) do
        try do
          {:ok, json_encode!(msg, opts)}
        rescue
          e in Protox.JsonEncodingError -> {:error, e}
        end
      end

      @spec json_encode!(struct(), keyword()) :: iodata() | no_return()
      def json_encode!(msg, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :encode)
        Protox.JsonEncode.encode!(msg, &json_library_wrapper.encode!(json_library, &1))
      end
    )

    (
      @deprecated "Use fields_defs()/0 instead"
      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs() do
        %{
          1 => {:echo, {:oneof, :payload}, {:message, SimpleWS.Proto.Echo}},
          2 => {:login, {:oneof, :payload}, {:message, SimpleWS.Proto.LoginRequest}}
        }
      end

      @deprecated "Use fields_defs()/0 instead"
      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs_by_name() do
        %{
          echo: {1, {:oneof, :payload}, {:message, SimpleWS.Proto.Echo}},
          login: {2, {:oneof, :payload}, {:message, SimpleWS.Proto.LoginRequest}}
        }
      end
    )

    (
      @spec fields_defs() :: list(Protox.Field.t())
      def fields_defs() do
        [
          %{
            __struct__: Protox.Field,
            json_name: "echo",
            kind: {:oneof, :payload},
            label: :optional,
            name: :echo,
            tag: 1,
            type: {:message, SimpleWS.Proto.Echo}
          },
          %{
            __struct__: Protox.Field,
            json_name: "login",
            kind: {:oneof, :payload},
            label: :optional,
            name: :login,
            tag: 2,
            type: {:message, SimpleWS.Proto.LoginRequest}
          }
        ]
      end

      [
        @spec(field_def(atom) :: {:ok, Protox.Field.t()} | {:error, :no_such_field}),
        (
          def field_def(:echo) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "echo",
               kind: {:oneof, :payload},
               label: :optional,
               name: :echo,
               tag: 1,
               type: {:message, SimpleWS.Proto.Echo}
             }}
          end

          def field_def("echo") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "echo",
               kind: {:oneof, :payload},
               label: :optional,
               name: :echo,
               tag: 1,
               type: {:message, SimpleWS.Proto.Echo}
             }}
          end

          []
        ),
        (
          def field_def(:login) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "login",
               kind: {:oneof, :payload},
               label: :optional,
               name: :login,
               tag: 2,
               type: {:message, SimpleWS.Proto.LoginRequest}
             }}
          end

          def field_def("login") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "login",
               kind: {:oneof, :payload},
               label: :optional,
               name: :login,
               tag: 2,
               type: {:message, SimpleWS.Proto.LoginRequest}
             }}
          end

          []
        ),
        def field_def(_) do
          {:error, :no_such_field}
        end
      ]
    )

    (
      @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
      def unknown_fields(msg) do
        msg.__uf__
      end

      @spec unknown_fields_name() :: :__uf__
      def unknown_fields_name() do
        :__uf__
      end

      @spec clear_unknown_fields(struct) :: struct
      def clear_unknown_fields(msg) do
        struct!(msg, [{unknown_fields_name(), []}])
      end
    )

    (
      @spec required_fields() :: []
      def required_fields() do
        []
      end
    )

    (
      @spec syntax() :: atom()
      def syntax() do
        :proto3
      end
    )

    [
      @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
      def default(:echo) do
        {:error, :no_default_value}
      end,
      def default(:login) do
        {:error, :no_default_value}
      end,
      def default(_) do
        {:error, :no_such_field}
      end
    ]

    (
      @spec file_options() :: nil
      def file_options() do
        nil
      end
    )
  end,
  defmodule SimpleWS.Proto.Response do
    @moduledoc false
    defstruct request_id: "", payload: nil, __uf__: []

    (
      (
        @spec encode(struct) :: {:ok, iodata} | {:error, any}
        def encode(msg) do
          try do
            {:ok, encode!(msg)}
          rescue
            e in [Protox.EncodingError, Protox.RequiredFieldsError] -> {:error, e}
          end
        end

        @spec encode!(struct) :: iodata | no_return
        def encode!(msg) do
          [] |> encode_payload(msg) |> encode_request_id(msg) |> encode_unknown_fields(msg)
        end
      )

      [
        defp encode_payload(acc, msg) do
          case msg.payload do
            nil -> acc
            {:echo, _field_value} -> encode_echo(acc, msg)
            {:login, _field_value} -> encode_login(acc, msg)
          end
        end
      ]

      [
        defp encode_request_id(acc, msg) do
          try do
            if msg.request_id == "" do
              acc
            else
              [acc, "\n", Protox.Encode.encode_string(msg.request_id)]
            end
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:request_id, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_echo(acc, msg) do
          try do
            {_, child_field_value} = msg.payload
            [acc, "\x12", Protox.Encode.encode_message(child_field_value)]
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:echo, "invalid field value"), __STACKTRACE__
          end
        end,
        defp encode_login(acc, msg) do
          try do
            {_, child_field_value} = msg.payload
            [acc, "\x1A", Protox.Encode.encode_message(child_field_value)]
          rescue
            ArgumentError ->
              reraise Protox.EncodingError.new(:login, "invalid field value"), __STACKTRACE__
          end
        end
      ]

      defp encode_unknown_fields(acc, msg) do
        Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
          case wire_type do
            0 ->
              [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

            1 ->
              [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

            2 ->
              len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
              [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

            5 ->
              [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
          end
        end)
      end
    )

    (
      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def decode(bytes) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e in [Protox.DecodingError, Protox.IllegalTagError, Protox.RequiredFieldsError] ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def decode!(bytes) do
            parse_key_value(bytes, struct(SimpleWS.Proto.Response))
          end
        )
      )

      (
        @spec parse_key_value(binary, struct) :: struct
        defp parse_key_value(<<>>, msg) do
          msg
        end

        defp parse_key_value(bytes, msg) do
          {field, rest} =
            case Protox.Decode.parse_key(bytes) do
              {0, _, _} ->
                raise %Protox.IllegalTagError{}

              {1, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)
                {[request_id: Protox.Decode.validate_string(delimited)], rest}

              {2, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   case msg.payload do
                     {:echo, previous_value} ->
                       {:payload,
                        {:echo,
                         Protox.MergeMessage.merge(
                           previous_value,
                           SimpleWS.Proto.Echo.decode!(delimited)
                         )}}

                     _ ->
                       {:payload, {:echo, SimpleWS.Proto.Echo.decode!(delimited)}}
                   end
                 ], rest}

              {3, _, bytes} ->
                {len, bytes} = Protox.Varint.decode(bytes)
                {delimited, rest} = Protox.Decode.parse_delimited(bytes, len)

                {[
                   case msg.payload do
                     {:login, previous_value} ->
                       {:payload,
                        {:login,
                         Protox.MergeMessage.merge(
                           previous_value,
                           SimpleWS.Proto.LoginResponse.decode!(delimited)
                         )}}

                     _ ->
                       {:payload, {:login, SimpleWS.Proto.LoginResponse.decode!(delimited)}}
                   end
                 ], rest}

              {tag, wire_type, rest} ->
                {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                {[
                   {msg.__struct__.unknown_fields_name(),
                    [value | msg.__struct__.unknown_fields(msg)]}
                 ], rest}
            end

          msg_updated = struct(msg, field)
          parse_key_value(rest, msg_updated)
        end
      )

      []
    )

    (
      @spec json_decode(iodata(), keyword()) :: {:ok, struct()} | {:error, any()}
      def json_decode(input, opts \\ []) do
        try do
          {:ok, json_decode!(input, opts)}
        rescue
          e in Protox.JsonDecodingError -> {:error, e}
        end
      end

      @spec json_decode!(iodata(), keyword()) :: struct() | no_return()
      def json_decode!(input, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :decode)

        Protox.JsonDecode.decode!(
          input,
          SimpleWS.Proto.Response,
          &json_library_wrapper.decode!(json_library, &1)
        )
      end

      @spec json_encode(struct(), keyword()) :: {:ok, iodata()} | {:error, any()}
      def json_encode(msg, opts \\ []) do
        try do
          {:ok, json_encode!(msg, opts)}
        rescue
          e in Protox.JsonEncodingError -> {:error, e}
        end
      end

      @spec json_encode!(struct(), keyword()) :: iodata() | no_return()
      def json_encode!(msg, opts \\ []) do
        {json_library_wrapper, json_library} = Protox.JsonLibrary.get_library(opts, :encode)
        Protox.JsonEncode.encode!(msg, &json_library_wrapper.encode!(json_library, &1))
      end
    )

    (
      @deprecated "Use fields_defs()/0 instead"
      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs() do
        %{
          1 => {:request_id, {:scalar, ""}, :string},
          2 => {:echo, {:oneof, :payload}, {:message, SimpleWS.Proto.Echo}},
          3 => {:login, {:oneof, :payload}, {:message, SimpleWS.Proto.LoginResponse}}
        }
      end

      @deprecated "Use fields_defs()/0 instead"
      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def defs_by_name() do
        %{
          echo: {2, {:oneof, :payload}, {:message, SimpleWS.Proto.Echo}},
          login: {3, {:oneof, :payload}, {:message, SimpleWS.Proto.LoginResponse}},
          request_id: {1, {:scalar, ""}, :string}
        }
      end
    )

    (
      @spec fields_defs() :: list(Protox.Field.t())
      def fields_defs() do
        [
          %{
            __struct__: Protox.Field,
            json_name: "requestId",
            kind: {:scalar, ""},
            label: :optional,
            name: :request_id,
            tag: 1,
            type: :string
          },
          %{
            __struct__: Protox.Field,
            json_name: "echo",
            kind: {:oneof, :payload},
            label: :optional,
            name: :echo,
            tag: 2,
            type: {:message, SimpleWS.Proto.Echo}
          },
          %{
            __struct__: Protox.Field,
            json_name: "login",
            kind: {:oneof, :payload},
            label: :optional,
            name: :login,
            tag: 3,
            type: {:message, SimpleWS.Proto.LoginResponse}
          }
        ]
      end

      [
        @spec(field_def(atom) :: {:ok, Protox.Field.t()} | {:error, :no_such_field}),
        (
          def field_def(:request_id) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "requestId",
               kind: {:scalar, ""},
               label: :optional,
               name: :request_id,
               tag: 1,
               type: :string
             }}
          end

          def field_def("requestId") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "requestId",
               kind: {:scalar, ""},
               label: :optional,
               name: :request_id,
               tag: 1,
               type: :string
             }}
          end

          def field_def("request_id") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "requestId",
               kind: {:scalar, ""},
               label: :optional,
               name: :request_id,
               tag: 1,
               type: :string
             }}
          end
        ),
        (
          def field_def(:echo) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "echo",
               kind: {:oneof, :payload},
               label: :optional,
               name: :echo,
               tag: 2,
               type: {:message, SimpleWS.Proto.Echo}
             }}
          end

          def field_def("echo") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "echo",
               kind: {:oneof, :payload},
               label: :optional,
               name: :echo,
               tag: 2,
               type: {:message, SimpleWS.Proto.Echo}
             }}
          end

          []
        ),
        (
          def field_def(:login) do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "login",
               kind: {:oneof, :payload},
               label: :optional,
               name: :login,
               tag: 3,
               type: {:message, SimpleWS.Proto.LoginResponse}
             }}
          end

          def field_def("login") do
            {:ok,
             %{
               __struct__: Protox.Field,
               json_name: "login",
               kind: {:oneof, :payload},
               label: :optional,
               name: :login,
               tag: 3,
               type: {:message, SimpleWS.Proto.LoginResponse}
             }}
          end

          []
        ),
        def field_def(_) do
          {:error, :no_such_field}
        end
      ]
    )

    (
      @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
      def unknown_fields(msg) do
        msg.__uf__
      end

      @spec unknown_fields_name() :: :__uf__
      def unknown_fields_name() do
        :__uf__
      end

      @spec clear_unknown_fields(struct) :: struct
      def clear_unknown_fields(msg) do
        struct!(msg, [{unknown_fields_name(), []}])
      end
    )

    (
      @spec required_fields() :: []
      def required_fields() do
        []
      end
    )

    (
      @spec syntax() :: atom()
      def syntax() do
        :proto3
      end
    )

    [
      @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
      def default(:request_id) do
        {:ok, ""}
      end,
      def default(:echo) do
        {:error, :no_default_value}
      end,
      def default(:login) do
        {:error, :no_default_value}
      end,
      def default(_) do
        {:error, :no_such_field}
      end
    ]

    (
      @spec file_options() :: nil
      def file_options() do
        nil
      end
    )
  end
]

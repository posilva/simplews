FROM elixir:1.17.3-alpine AS builder 

ENV MIX_ENV=prod

# base building deps 
RUN apk add --update --no-cache bash build-base git openssl

WORKDIR /app

RUN mkdir config
RUN mkdir lib
# copy base files 
COPY mix.exs mix.lock ./
COPY config config 
COPY lib lib 

# install package managers for elixir and erlang 
RUN mix local.hex --force && \
  mix local.rebar --force 

# fetch dependencies and compile code 
RUN mix do deps.get, deps.compile  
RUN mix do compile, release

### Runtime application
FROM alpine:3.19 AS app

WORKDIR /app

RUN apk add --update --no-cache bash openssl ncurses-libs libstdc++ 

COPY --from=builder /app/_build/prod/rel/simplews ./ 

RUN chown nobody:nobody /app

ENV HOME=/app 

USER nobody


EXPOSE 4000 

CMD ["bin/simplews", "start"]


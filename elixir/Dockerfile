FROM elixir:1.8.1

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR
COPY config/ $WORKDIR/config/
COPY lib/ $WORKDIR/lib/
COPY test/ $WORKDIR/test/
COPY .formatter.exs $WORKDIR/
COPY mix.exs $WORKDIR/
COPY mix.lock $WORKDIR/
RUN mix local.hex --force
RUN mix deps.get
RUN mix escript.build
RUN mv calc run
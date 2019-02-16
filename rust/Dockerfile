FROM rust:1.31

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR

COPY src/ $WORKDIR/src
COPY Cargo.lock $WORKDIR
COPY Cargo.toml $WORKDIR

RUN cargo build --release
RUN mv ./target/release/calc ./run
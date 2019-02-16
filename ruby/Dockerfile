FROM ruby:2.5

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR

COPY run $WORKDIR/
RUN chmod +x ./run

COPY src/ $WORKDIR/
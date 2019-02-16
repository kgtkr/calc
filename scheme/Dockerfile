FROM ubuntu:18.04

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR

RUN apt update
RUN apt install gauche -y

COPY run $WORKDIR
RUN chmod +x ./run

COPY src/ $WORKDIR

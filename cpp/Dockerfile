FROM gcc:8.2.0

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR
COPY main.cpp $WORKDIR/
RUN g++ main.cpp -o run

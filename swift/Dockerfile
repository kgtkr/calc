FROM swift:4.2.2

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR

COPY run $WORKDIR
RUN chmod +x ./run

COPY Sources $WORKDIR/Sources
COPY Tests $WORKDIR/Tests
COPY Package.swift $WORKDIR

RUN swift build

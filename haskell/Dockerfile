FROM haskell:8.4.3

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR

COPY ChangeLog.md $WORKDIR/
COPY README.md $WORKDIR/
COPY app/ $WORKDIR/app/
COPY src/ $WORKDIR/src/
COPY test/ $WORKDIR/test/
COPY package.yaml $WORKDIR/
COPY Setup.hs $WORKDIR/
COPY stack.yaml $WORKDIR/
COPY run $WORKDIR/

RUN stack build
RUN chmod +x ./run
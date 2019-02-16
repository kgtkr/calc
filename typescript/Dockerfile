FROM node:8.12

ENV WORKDIR=/home/calc
WORKDIR $WORKDIR

COPY run $WORKDIR
RUN chmod +x ./run

COPY package.json $WORKDIR/
COPY package-lock.json $WORKDIR/

RUN npm i

COPY tsconfig.json $WORKDIR/
COPY src $WORKDIR/src

RUN npm run build

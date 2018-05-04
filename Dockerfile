FROM ubuntu:16.04 as base

COPY app/cf/conf/* /PredictionIO/conf/

ENV WORKDIR "/ebsa/app/cf"

ADD app/cf/* ${WORKDIR}

WORKDIR "${WORKDIR}"

RUN pio eventserver &


FROM ubuntu:16.04 as base

COPY app/cf/conf/* /PredictionIO/conf/

ENV WORKDIR "/ebsa/app"

ADD app/* ${WORKDIR}

WORKDIR "${WORKDIR}"

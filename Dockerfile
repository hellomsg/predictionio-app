FROM registry.cn-hangzhou.aliyuncs.com/flipboardchina/predictionio

COPY app/cf/conf/* /PredictionIO/conf/

ENV WORKDIR "/ebsa/app/cf"

ADD app/cf/* ${WORKDIR}

WORKDIR "${WORKDIR}"

RUN pio build --verbose

ENTRYPOINT ["entrypoint.sh"]

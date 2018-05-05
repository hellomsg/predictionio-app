FROM registry.cn-hangzhou.aliyuncs.com/flipboardchina/predictionio

COPY app/cf/conf/* /PredictionIO/conf/

ENV WORKDIR "/ebsa/app/cf/"

COPY app/cf/* ${WORKDIR}

WORKDIR "${WORKDIR}"

#RUN pio build --verbose

ENTRYPOINT ["entrypoint.sh"]

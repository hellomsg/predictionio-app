FROM ubuntu:16.04 as base

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm
RUN echo "export > /etc/envvars" >> /root/.bashrc && \
    echo "export PS1='\[\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" | tee -a /root/.bashrc /etc/skel/.bashrc && \
    echo "alias tcurrent='tail /var/log/*/current -f'" | tee -a /root/.bashrc /etc/skel/.bashrc

RUN apt-get update
RUN apt-get install -y locales && locale-gen en_US.UTF-8 && dpkg-reconfigure locales
ENV LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Runit
RUN apt-get install -y --no-install-recommends runit
CMD bash -c 'export > /etc/envvars && /usr/sbin/runsvdir-start'

# Utilities
RUN apt-get install -y --no-install-recommends vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc iproute python ssh rsync gettext-base

#Install Oracle Java 8
RUN add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt install oracle-java8-unlimited-jce-policy && \
    rm -r /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle


#Spark
RUN wget -O - http://www-us.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz | tar zx
RUN mv /spark* /spark

#ElasticSearch
#RUN wget -O - https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.2.tar.gz | tar zx
#RUN mv /elasticsearch* /elasticsearch

#HBase
#RUN wget -O - http://www-us.apache.org/dist/hbase/1.2.6/hbase-1.2.6-bin.tar.gz | tar zx
#RUN mv /hbase* /hbase
#RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /hbase/conf/hbase-env.sh 

#Python SDK
RUN apt-get install -y python-pip
RUN pip install pytz
RUN pip install predictionio

#For Spark MLlib
RUN apt-get install -y libgfortran3 libatlas3-base libopenblas-base

#PredictionIO

RUN wget -O - http://www-us.apache.org/dist/predictionio/0.12.1/apache-predictionio-0.12.1-bin.tar.gz | tar zx
RUN mv PredictionIO* /PredictionIO

RUN wget -O - https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz | tar zx
RUN mv mysql-connector-java-5.1.46/mysql-connector-java-5.1.46.jar PredictionIO/lib/ && \
    rm -rf mysql-connector-java-5.1.46

#RUN useradd elasticsearch
#RUN chown -R elasticsearch /elasticsearch

ENV PIO_HOME /PredictionIO
ENV PATH $PATH:$PIO_HOME/bin

#Download SBT
RUN cd /PredictionIO && sbt/sbt package 

ARG BUILD_INFO
LABEL BUILD_INFO=$BUILD_INFO

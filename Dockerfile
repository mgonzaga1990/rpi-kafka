FROM openjdk:16-slim

ENV ZOO_SERVERS=2

RUN apt-get update && apt-get install -y wget

# Download kafka
#RUN wget -c https://downloads.apache.org/kafka/2.6.0/kafka-2.6.0-src.tgz
RUN wget -c https://downloads.apache.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz

# Untar and Move
RUN tar -xzf kafka_2.13-2.6.0.tgz -C /opt \
        && rm -r kafka_2.13-2.6.0.tgz \
        && mv /opt/kafka_* /opt/kafka

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh

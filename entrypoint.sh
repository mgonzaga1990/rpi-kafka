#!/bin/bash

set -e

echo 'Starting up'

echo 'Removing existing server.properties'
rm /opt/kafka/config/server.properties

CONFIG=/opt/kafka/config

# setup broker id
 id="${HOSTNAME//[!0-9]/}"

# set up ip address
 IP=$(hostname -I)
 echo "listeners=PLAINTEXT://${IP// /}:9092" > "$CONFIG/server.properties"

# other properties
{
 echo "broker.id=${id}"
 echo 'num.network.threads=3'
 echo 'num.io.threads=8'
 echo 'socket.send.buffer.bytes=102400'
 echo 'socket.receive.buffer.bytes=102400'
 echo 'socket.request.max.bytes=104857600'
 echo 'log.dirs=/tmp/kafka-logs'
 echo 'num.partitions=1'
 echo 'num.recovery.threads.per.data.dir=1'
 echo 'offsets.topic.replication.factor=1'
 echo 'transaction.state.log.replication.factor=1'
 echo 'transaction.state.log.min.isr=1'
 echo 'log.segment.bytes=1073741824'
 echo 'log.retention.check.interval.ms=300000'
} >> "$CONFIG/server.properties"

# zookeeper server(s)
 server=''
 x=$ZOO_SERVERS
 while [ $x -gt -1 ];
  do
    index=$(($x + 1))
    server="${server},zk-$x.zk-hs.default.svc.cluster.local:2181"
    x=$(($x-1))
  done
 echo "zookeeper.connect=${server}" >> "$CONFIG/server.properties"

# other zookeeper property
{
 echo 'zookeeper.connection.timeout.ms=6000'
 echo 'group.initial.rebalance.delay.ms=0'
} >> "$CONFIG/server.properties"


./opt/kafka/bin/kafka-server-start.sh ${CONFIG}/server.properties

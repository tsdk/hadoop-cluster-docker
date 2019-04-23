#!/bin/bash

# the default node number is 3 
N=${1:-3}


# start hadoop master container
docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
docker run -itd \
                --net=hadoop \
                -P \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname master.com \
                tsdk/hadoop:1.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	docker run -itd \
	                --net=hadoop \
                    -P \
	                --name hadoop-slave$i \
	                --hostname slave$i.com \
	                tsdk/hadoop:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
docker exec -it hadoop-master bash

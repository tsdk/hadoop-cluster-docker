#!/bin/bash

if [ `whoami` != "root" ];then
echo "sudo $0 $@"
exit
fi

#get pipework
#git clone https://github.com/jpetazzo/pipework.git

# the default node number is 3 
N=${1:-3}
gw="192.168.82.2"

hosts="${gw}00 hadoop-master"
i=1
while [ $i -lt $N ]
do
    hosts="$hosts\n${gw}0$i hadoop-slave$i"
    i=$(( $i + 1 ))
done

# start hadoop master container
pipework br0 hadoop-master ${gw}00/24@$gw
docker exec -it hadoop-master bash -c "echo \"\$(sed 's/^.*master.com$/${hosts}/' /etc/hosts)\" > /etc/hosts"

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
    pipework br0 hadoop-slave$i ${gw}0$i/24@$gw
    docker exec -it hadoop-slave$i bash -c "echo \"\$(sed 's/^.*slave$i.com$/${hosts}/' /etc/hosts)\" > /etc/hosts"
	i=$(( $i + 1 ))
done 

docker exec -it hadoop-master bash -c "/root/start-hadoop.sh"

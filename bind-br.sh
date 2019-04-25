#!/bin/bash

# only run one time for your machine
if [ `whoami` != "root" ];then
echo "sudo $0 $@"
exit
fi

# the default bridge is br0
N=${1:-0}
# your gateway
gw="192.168.82.2"
# your localIP/mask
net="192.168.82.100/24"

yum install -y bridge-utils
ip addr add $net dev br$N; \
ip addr del $net dev eth0; \
brctl addif br$N eth0; \
ip route del default; \
ip route add default via $gw dev br$N


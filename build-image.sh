#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop image\n"
#wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz
docker build -t tsdk/hadoop:1.0 .

echo ""

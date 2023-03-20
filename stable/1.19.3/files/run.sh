#!/bin/bash
# Copyright (c) 2022 fithwum
# All rights reserved

MC_VERSION=1.19.3

cd /MCserver
JAR=./MCserver_${MC_VERSION}.jar

while [ true ]; do
  java -Xmx4G -Xms1024M -Xmn1G -jar $JAR nogui
  if [ $? -eq 0 ]; then
    break
  fi
done

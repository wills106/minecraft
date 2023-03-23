#!/bin/bash
# Copyright (c) 2022 fithwum
# All rights reserved

MC_VERSION=1.19.4
FABRIC_VERSION=0.14.18

cd /MCserver
JAR=./fabric-${MC_VERSION}-${FABRIC_VERSION}.jar

while [ true ]; do
  java -Xmx8G -Xms2048M -Xmn2G -jar $JAR nogui
  if [ $? -eq 0 ]; then
    break
  fi
done

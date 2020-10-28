#!/bin/bash
# Copyright (c) 2020 fithwum
# All rights reserved

cd /MCserver
JAR=./MCserver.jar

while [ true ]; do
  java -Xmx4G -Xms1024M -Xmn1G -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -jar $JAR nogui
  if [ $? -eq 0 ]; then
    break
  fi
done
#!/bin/bash
# Copyright (c) 2022 fithwum
# All rights reserved

MC_VERSION=1.19.3
FORGE_VERSION=44.1.0

cd /MCserver

chmod +x server_forge-${MC_VERSION}-${FORGE_VERSION}.jar
java -jar server_forge-${MC_VERSION}-${FORGE_VERSION}.jar --installServer > /MCserver

# JAR=./server_forge-${MC_VERSION}-${FORGE_VERSION}.jar

# while [ true ]; do
#   java -Xmx4G -Xms1024M -Xmn1G -jar $JAR nogui
#   if [ $? -eq 0 ]; then
#     break
#   fi
# done

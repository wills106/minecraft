#!/bin/bash
# Copyright (c) 2022 fithwum
# All rights reserved

# Display setup
export DISPLAY=0

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft Server version."
MC_VERSION_OLD=
FABRIC_VERSION_OLD=0.14.18
MC_VERSION=1.18.1
FABRIC_VERSION=0.14.19

SERVER_FILE=https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${FABRIC_VERSION}/0.11.2/server/jar
MC_RUN_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/files/run-fabric.sh

EULA_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/fabric/fabric-${MC_VERSION}/files/eula.txt
OPS_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/fabric/fabric-${MC_VERSION}/files/ops.json
WHITELIST_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/fabric/fabric-${MC_VERSION}/files/whitelist.json

# Main install (Debian).
# Check for files in /MCserver and download if needed.
if [ -e /MCserver/fabric-${MC_VERSION}-${FABRIC_VERSION}.jar ]
	then
		echo " "
		echo "INFO ! fabric-${MC_VERSION}-${FABRIC_VERSION}.jar found starting now."
	else
		echo " "
		echo "WARNING ! fabric-${MC_VERSION}-${FABRIC_VERSION}.jar is out of date/missing ... will download now."
			echo " "
			echo "INFO ! Cleaning old files."
			mkdir /MCserver/old-server-versions/${MC_VERSION_OLD}-${FABRIC_VERSION_OLD}
			mv /MCserver/fabric-${MC_VERSION_OLD}-*.jar /MCserver/old-server-versions/${MC_VERSION_OLD}-${FABRIC_VERSION_OLD}
			mv /MCserver/fabric-*-${FABRIC_VERSION_OLD}.jar /MCserver/old-server-versions/${MC_VERSION_OLD}-${FABRIC_VERSION_OLD}
			wget --no-cache ${SERVER_FILE} -O /MCserver/fabric-${MC_VERSION}-${FABRIC_VERSION}.jar
fi

sleep 1

# Looking for run-fabric_${MC_VERSION}.sh
if [ -e /MCserver/run-fabric_${MC_VERSION}.sh ]
	then
		echo " "
		echo "INFO ! run-fabric_${MC_VERSION}.sh found ... will use existing file."
	else
		echo " "
		echo "WARNING ! run-fabric_${MC_VERSION_OLD}.sh is out of date/missing ... will download now."
		mv /MCserver/run-fabric_${MC_VERSION_OLD}.sh /MCserver/old-server-versions/${MC_VERSION_OLD}
		wget --no-cache ${MC_RUN_FILE} -O /MCserver/run-fabric_${MC_VERSION}.sh
fi

# Check for needed files
if [ -e /MCserver/eula.txt ]
	then
		echo " "
		echo "INFO ! eula.txt found ... will use existing file."
	else
		echo " "
		echo "WARNING ! eula.txt is missing ... will download now."
		wget --no-cache ${EULA_FILE} -O /MCserver/eula.txt
fi

if [ -e /MCserver/ops.json ]
	then
		echo " "
		echo "INFO ! ops.json found ... will use existing file."
	else
		echo " "
		echo "WARNING ! ops.json is missing ... will download now."
		wget --no-cache ${OPS_FILE} -O /MCserver/ops.json
fi

if [ -e /MCserver/whitelist.json ]
	then
		echo " "
		echo "INFO ! whitelist.json found ... will use existing file."
	else
		echo " "
		echo "WARNING ! whitelist.json is missing ... will download now."
		wget --no-cache ${WHITELIST_FILE} -O /MCserver/whitelist.json
fi

sleep 1

# Set permissions.
chown 99:100 -R /MCserver
chmod 777 -R /MCserver
chmod +x /MCserver/run-fabric_${MC_VERSION}.sh

sleep 1

# Run Minecraft server.
echo " "
echo "INFO ! Starting Minecraft Server ${MC_VERSION}"
exec /MCserver/run-fabric_${MC_VERSION}.sh --dataPath=/MCserver

exit

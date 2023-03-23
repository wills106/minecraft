#!/bin/bash
# Copyright (c) 2022 fithwum
# All rights reserved

# Display setup
export DISPLAY=0

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft Server version."
MC_VERSION_OLD=
FORGE_VERSION_OLD=
MC_VERSION=1.19.3
FORGE_VERSION=44.1.0
MC_SERVER_FILE=https://maven.minecraftforge.net/net/minecraftforge/forge/${MC_VERSION}-${FORGE_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar
MC_RUN_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/run.sh
EULA_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/eula.txt
OPS_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/ops.json
WHITELIST_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/whitelist.json
SERVER_PROPERTIES=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/server.properties

# Main install (Debian).
# Check for files in /MCserver and download if needed.
if [ -e /MCserver/server_forge-${MC_VERSION}.jar ]
	then
		echo " "
		echo "INFO ! server_forge-${MC_VERSION}.jar found starting now."
	else
		echo " "
		echo "WARNING ! server_forge-${MC_VERSION}.jar is out of date/missing ... will download now."
			echo " "
			echo "INFO ! Cleaning old files."
			mkdir /MCserver/old-server-versions/${MC_VERSION_OLD}-${FORGE_VERSION_OLD}
			mv /MCserver/server_forge-${MC_VERSION_OLD}-${FORGE_VERSION}.jar /MCserver/old-server-versions/${MC_VERSION_OLD}-${FORGE_VERSION_OLD}
			wget --no-cache ${MC_SERVER_FILE} -O /MCserver/server_forge-${MC_VERSION}-${FORGE_VERSION}.jar
			# chmod +x /MCserver/server_forge-${MC_VERSION}-${FORGE_VERSION}.jar
			# java -jar /MCserver/server_forge-${MC_VERSION}-${FORGE_VERSION}.jar --installServer > /MCserver
			# ./MCserver/server_forge-${MC_VERSION}-${FORGE_VERSION}.jar --installServer
fi

sleep 1

# Looking for run_${MC_VERSION}.sh
if [ -e /MCserver/run_${MC_VERSION}.sh ]
	then
		echo " "
		echo "INFO ! run_${MC_VERSION}.sh found ... will use existing file."
	else
		echo " "
		echo "WARNING ! run_${MC_VERSION_OLD}.sh is out of date/missing ... will download now."
		mv /MCserver/run_${MC_VERSION_OLD}.sh /MCserver/old-server-versions/${MC_VERSION_OLD}
		wget --no-cache ${MC_RUN_FILE} -O /MCserver/run_${MC_VERSION}.sh
fi

sleep 1

# Check for needed files
if [ -e /MCserver/${EULA_FILE} ]
	then
		echo " "
		echo "INFO ! eula.txt found ... will use existing file."
	else
		echo " "
		echo "WARNING ! eula.txt is missing ... will download now."
		wget --no-cache ${EULA_FILE} -O /MCserver/eula.txt
fi

if [ -e /MCserver/${OPS_FILE} ]
	then
		echo " "
		echo "INFO ! ops.json found ... will use existing file."
	else
		echo " "
		echo "WARNING ! ops.json is missing ... will download now."
		wget --no-cache ${OPS_FILE} -O /MCserver/ops.json
fi

if [ -e /MCserver/${WHITELIST_FILE} ]
	then
		echo " "
		echo "INFO ! whitelist.json found ... will use existing file."
	else
		echo " "
		echo "WARNING ! whitelist.json is missing ... will download now."
		wget --no-cache ${WHITELIST_FILE} -O /MCserver/whitelist.json
fi

if [ -e /MCserver/${SERVER_PROPERTIES} ]
	then
		echo " "
		echo "INFO ! server.properties found ... will use existing file."
	else
		echo " "
		echo "WARNING ! server.properties is missing ... will download now."
		wget --no-cache ${SERVER_PROPERTIES} -O /MCserver/server.properties
fi

sleep 1

# Set permissions.
chown 99:100 -R /MCserver
chmod 777 -R /MCserver
chmod +x /MCserver/run_${MC_VERSION}.sh
chmod +x /MCserver/server_forge-${MC_VERSION}-${FORGE_VERSION}.jar

sleep 1

# Run Minecraft server.
echo " "
echo "INFO ! Starting Minecraft Server ${MC_VERSION}"
# exec /MCserver/run_${MC_VERSION}.sh --dataPath=/MCserver

exit

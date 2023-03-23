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

MC_SERVER_FILE=https://nextcloud.fithwum.tech/s/Ay2DFBiNzRAxzjS/download/forge-${MC_VERSION}-${FORGE_VERSION}.zip
MC_RUN_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/run.sh

EULA_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/eula.txt
OPS_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/ops.json
WHITELIST_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/whitelist.json
SERVER_PROPERTIES=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/server.properties

# Main install (Debian).
# Check for files in /MCserver and download if needed.
if [ -e /MCserver/forge-${MC_VERSION}-${FORGE_VERSION}.zip ]
	then
		echo " "
		echo "INFO ! forge-${MC_VERSION}-${FORGE_VERSION}.zip found starting now."
	else
		echo " "
		echo "WARNING ! forge-${MC_VERSION}-${FORGE_VERSION}.zip is out of date/missing ... will download now."
			echo " "
			echo "INFO ! Cleaning old files."
			mkdir /MCserver/old-server-versions/${MC_VERSION_OLD}-${FORGE_VERSION_OLD}
			mv /MCserver/forge-${MC_VERSION_OLD}-${FORGE_VERSION}.zip /MCserver/old-server-versions/${MC_VERSION_OLD}-${FORGE_VERSION_OLD}
			wget --no-cache ${MC_SERVER_FILE} -O /MCserver/forge-${MC_VERSION}-${FORGE_VERSION}.zip
			unzip /MCserver/forge-${MC_VERSION}-${FORGE_VERSION}.zip -d /MCserver
fi

sleep 1

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

if [ -e /MCserver/server.properties ]
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
chmod +x /MCserver/run.sh

sleep 1

# Run Minecraft server.
echo " "
echo "INFO ! Starting Minecraft Server ${MC_VERSION}"
exec /MCserver/run.sh --dataPath=/MCserver

exit

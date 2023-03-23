#!/bin/bash
# Copyright (c) 2022 fithwum
# All rights reserved

# Display setup
export DISPLAY=0

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft Server version."
MC_VERSION=1.19.3

EULA_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/eula.txt
OPS_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/ops.json
WHITELIST_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-${MC_VERSION}/files/whitelist.json

# Main install (Debian).
# Check for files in /MCserver and download if needed.
# Looking for run-forge_${MC_VERSION}.sh
if [ -e /MCserver/run-forge_${MC_VERSION}.sh ]
	then
		echo " "
		echo "INFO ! run-forge_${MC_VERSION}.sh found ... will use existing file."
	else
		echo " "
		echo "WARNING ! run-forge_${MC_VERSION_OLD}.sh is out of date/missing ... will download now."
		mv /MCserver/run.sh /MCserver/run-forge_${MC_VERSION}.sh
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
chmod +x /MCserver/run-forge_${MC_VERSION}.sh

sleep 1

# Run Minecraft server.
echo " "
echo "INFO ! Starting Minecraft Server ${MC_VERSION}"
exec /MCserver/run-forge_${MC_VERSION}.sh --dataPath=/MCserver

exit

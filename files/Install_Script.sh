#!/bin/bash
# Copyright (c) 2020 fithwum
# All rights reserved

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft server version."
MC_VERSION=1.16.3
CHANGELOG=/MCserver/run_${MC_VERSION}.sh

# Main install (debian).

# Check for files in /MCserver and download/create if needed.
if [ -e "${CHANGELOG}" ]
	then
		echo " "
		echo "INFO ! minecraft server found starting server."
	else
		echo " "
		echo "WARNING ! minecraft server not found or is outdated downloading new copy."
			echo " "
			echo "INFO ! Cleaning old files."
			rm -f /MCserver/minecraft_server.jar /MCserver/run_${MC_VERSION}.sh
			wget --no-cache https://launcher.mojang.com/v1/objects/f02f4473dbf152c23d7d484952121db0b36698cb/server.jar -O /MCserver/MCserver.jar
fi

sleep 1

# Looking for run_${MC_VERSION}.sh
if [ -e /MCserver/run_${MC_VERSION}.sh ]
	then
		echo " "
		echo "INFO ! run_${MC_VERSION}.sh found ... will not download."
	else
		echo " "
		echo "WARNING ! run_${MC_VERSION}.sh not found ... will download new copy."
		wget --no-cache https://raw.githubusercontent.com/fithwum/minecraft/master/files/run.sh -O /MCserver/run_${MC_VERSION}.sh
fi

sleep 1

# Check for EULA
if [ ! -f /MCserver/eula.txt ]; then
	:
else
	if [ "${ACCEPT_EULA}" == "false" ]; then
		if grep -rq 'eula=true' /MCserver/eula.txt; then
			sed -i '/eula=true/c\eula=false' /MCserver/eula.txt
		fi
			echo " "
			echo "WARNING ! EULA not accepted, you must accept the EULA"
			echo "			to start the Server, putting server in sleep mode"
		sleep infinity
    fi
fi

sleep 1

if [ ! -f /MCserver/eula.txt ]; then
	echo " "
	echo "WARNING ! EULA not found please stand by..."
	sleep 5
fi
if [ "${ACCEPT_EULA}" == "true" ]; then
	if grep -rq 'eula=false' /MCserver/eula.txt; then
		sed -i '/eula=false/c\eula=true' /MCserver/eula.txt
		echo " "
		echo "INFO ! EULA accepted, server restarting, please wait..."
		sleep 1
		exec /MCserver/run_${MC_VERSION}.sh --dataPath=/MCserver
		exit 0
	fi
elif [ "${ACCEPT_EULA}" == "false" ]; then
	echo " "
	echo "WARNING ! EULA not accepted, you must accept the EULA"
	echo "			to start the Server, putting server in sleep mode"
	sleep infinity
else
	echo " "
	echo "WARNING ! Something went wrong, please check EULA variable"
fi

sleep 1

# Set permissions.
chown 99:100 -R /MCserver
chmod 777 -R /MCserver
chmod +x /MCserver/run_${MC_VERSION}.sh
chmod +x /MCserver/MCserver.jar

sleep 1

# Run Minecraft server.
echo " "
echo "INFO ! Starting Minecraft server ${MC_VERSION}"
exec /MCserver/run_${MC_VERSION}.sh --dataPath=/MCserver

exit

#!/bin/bash
# Copyright (c) 2018 fithwum
# All rights reserved

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft server version."
MC_VERSION=1.16.1
CHANGELOG=/MCserver/run_${MC_VERSION}.sh

# Main install (debian).

# Looking for run_${MC_VERSION}.sh
if [ -e /MCserver/run_${MC_VERSION}.sh ]
	then
		echo " "
		echo "INFO ! run_${MC_VERSION}.sh found ... will not download."
	else
		echo " "
		echo "WARNING ! run_${MC_VERSION}.sh not found ... will download new copy."
		wget --no-cache --progress=bar:force:noscroll https://raw.githubusercontent.com/fithwum/minecraft/master/files/run.sh -O /MCserver/run_${MC_VERSION}.sh
fi

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
			wget --no-cache --progress=bar:force:noscroll https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar -O /MCserver/minecraft_server.jar
			sleep 1
fi

# Check for EULA
if [ ! -f MCserver/eula.txt ]; then
	:
else
	if [ "${ACCEPT_EULA}" == "false" ]; then
		if grep -rq 'eula=true' MCserver/eula.txt; then
			sed -i '/eula=true/c\eula=false' MCserver/eula.txt
		fi
			echo " "
			echo "WARNING ! EULA not accepted, you must accept the EULA"
			echo "			to start the Server, putting server in sleep mode"
		sleep infinity
    fi
fi

if [ ! -f MCserver/eula.txt ]; then
	echo " "
	echo "WARNING ! EULA not found please stand by..."
	sleep 5
fi
if [ "${ACCEPT_EULA}" == "true" ]; then
	if grep -rq 'eula=false' MCserver/eula.txt; then
		sed -i '/eula=false/c\eula=true' MCserver/eula.txt
		echo " "
		echo "INFO ! EULA accepted, server restarting, please wait..."
		sleep 1
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
chmod +x /MCserver/minecraft_server.jar

# Run teamspeak server.
echo " "
echo "INFO ! Starting Minecraft server ${MC_VERSION}"
exec /MCserver/run_${MC_VERSION}.sh

exit

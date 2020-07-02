#!/bin/bash
# Copyright (c) 2018 fithwum
# All rights reserved

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft server version."
MC_VERSION=1.16.1
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
			wget --no-cache --progress=bar:force:noscroll https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar -O /MCserver/MCserver.jar
			sleep 1
fi

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

sleep 1

# Set permissions.
chown 99:100 -R /MCserver
chmod 777 -R /MCserver
chmod +x /MCserver/run_${MC_VERSION}.sh
chmod +x /MCserver/MCserver.jar

# Run teamspeak server.
echo " "
echo "INFO ! Starting Minecraft server ${MC_VERSION}"
exec /MCserver/run_${MC_VERSION}.sh

exit

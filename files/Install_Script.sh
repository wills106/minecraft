#!/bin/bash
# Copyright (c) 2020 fithwum
# All rights reserved

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft server version."
MC_VERSION_OLD=1.18.1
MC_VERSION=1.18.2

# Main install (Debian).

# Check for files in /MCserver and download/create if needed.
if [ -e "${CHANGELOG}" ]
	then
		echo " "
		echo "INFO ! Minecraft server found starting server."
	else
		echo " "
		echo "WARNING ! Minecraft server not found or is outdated downloading new copy."
			echo " "
			echo "INFO ! Cleaning old files."
			mkdir /MCserver/old-server-versions/${MC_VERSION_OLD}
			mv /MCserver/MCserver_${MC_VERSION_OLD}.jar /MCserver/old-server-versions/${MC_VERSION_OLD}
			mv /MCserver/run_${MC_VERSION_OLD}.sh /MCserver/old-server-versions/${MC_VERSION_OLD}
			wget --no-cache https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar -O /MCserver/MCserver_${MC_VERSION}.jar
fi

sleep 1

# Looking for run_${MC_VERSION}.sh
if [ -e /MCserver/run_${MC_VERSION}.sh ]
	then
		echo " "
		echo "INFO ! run_${MC_VERSION}.sh found ... will use existing run file."
	else
		echo " "
		echo "WARNING ! run_${MC_VERSION_OLD}.sh is out of date ... update will be downloaded."
		mv /MCserver/run_${MC_VERSION_OLD}.sh /MCserver/old-server-versions/${MC_VERSION_OLD}
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
chmod +x /MCserver/MCserver_${MC_VERSION}.jar

sleep 1

# Run Minecraft server.
echo " "
echo "INFO ! Starting Minecraft server ${MC_VERSION}"
exec /MCserver/run_${MC_VERSION}.sh --dataPath=/MCserver

exit

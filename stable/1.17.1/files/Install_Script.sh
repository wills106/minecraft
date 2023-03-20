#!/bin/bash
# Copyright (c) 2022 fithwum
# All rights reserved

# Variables.
echo " "
echo "INFO ! Checking for latest Minecraft Server version."
MC_VERSION_OLD=1.17
MC_VERSION=1.17.1
MC_SERVER_FILE=https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
MC_RUN_FILE=https://raw.githubusercontent.com/fithwum/minecraft/master/stable/${MC_VERSION}/files/run.sh

# Main install (Debian).
# Check for files in /MCserver and download if needed.
if [ -e /MCserver/MCserver_${MC_VERSION}.jar ]
	then
		echo " "
		echo "INFO ! MCserver_${MC_VERSION}.jar found starting now."
	else
		echo " "
		echo "WARNING ! MCserver_${MC_VERSION}.jar is out of date/missing ... will download now."
			echo " "
			echo "INFO ! Cleaning old files."
			mkdir /MCserver/old-server-versions/${MC_VERSION_OLD}
			mv /MCserver/MCserver_${MC_VERSION_OLD}.jar /MCserver/old-server-versions/${MC_VERSION_OLD}
			mv /MCserver/run_${MC_VERSION_OLD}.sh /MCserver/old-server-versions/${MC_VERSION_OLD}
			wget --no-cache ${MC_SERVER_FILE} -O /MCserver/MCserver_${MC_VERSION}.jar
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
echo "INFO ! Starting Minecraft Server ${MC_VERSION}"
exec /MCserver/run_${MC_VERSION}.sh --dataPath=/MCserver

exit

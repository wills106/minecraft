FROM fithwum/debian-base:bullseye
LABEL maintainer "fithwum"

ENV ACCEPT_EULA="false"
ENV GAME_PORT=25565

# URL's for files
ARG INSTALL_SCRIPT=https://raw.githubusercontent.com/fithwum/minecraft/master/forge/forge-1.18.2/files/Install_Script.sh

# Install java-17 & Dependencies.
RUN apt-get -y update \
	&& apt-get -y --fix-broken install \
	&& apt-get install -y software-properties-common openjdk-17-jdk-headless \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& update-ca-certificates -f;

# Folder creation.
RUN mkdir -p /MCserver /MCtemp \
	&& chmod 777 -R /MCserver /MCtemp \
	&& chown 99:100 -R /MCserver /MCtemp
ADD "${INSTALL_SCRIPT}" /MCtemp
RUN chmod +x /MCtemp/Install_Script.sh

# Directory where data is stored
VOLUME /MCserver

# 25565 Default.
EXPOSE 25565/udp 25565/tcp

# Run command
CMD [ "/bin/bash", "./MCtemp/Install_Script.sh" ]

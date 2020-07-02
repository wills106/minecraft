FROM fithwum/debian-base
MAINTAINER fithwum

ENV ACCEPT_EULA="false"
ENV GAME_PORT=25565


# URL's for files
ARG INSTALL_SCRIPT=https://raw.githubusercontent.com/fithwum/minecraft/master/files/Install_Script.sh

# Install java8 & dependencies.
RUN apt-get -y update \
	&& apt-get install -y openjdk-8-jdk ca-certificates-java \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*\
	&& update-ca-certificates -f;

# folder creation.
RUN mkdir -p /MCserver /MCtemp \
	&& chmod 777 -R /MCserver /MCtemp \
	&& chown 99:100 -R /MCserver /MCtemp
ADD "${INSTALL_SCRIPT}" /MCserver
RUN chmod +x /MCserver/Install_Script.sh

# directory where data is stored
WORKDIR /MCserver

# 25565 default.
EXPOSE 25565/udp 25565/tcp

# Run command
CMD [ "/bin/bash", "./MCserver/Install_Script.sh" ]

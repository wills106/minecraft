FROM fithwum/debian-base
MAINTAINER fithwum

# URL's for files
ARG INSTALL_SCRIPT=https://raw.githubusercontent.com/fithwum/minecraft/master/files/Install_Script.sh

# Install dependencies and folder creation
RUN apt-get install libstdc++ default-jre && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /MCserver /MCtemp \
	&& chmod 777 -R /MCserver /MCtemp \
	&& chown 99:100 -R /MCserver /MCtemp
ADD "${INSTALL_SCRIPT}" /MCtemp
RUN chmod +x /MCtemp/Install_Script.sh

# directory where data is stored
VOLUME /MCserver

# 25565 default.
EXPOSE 25565/udp 25565/tcp

# Run command
CMD [ "/bin/bash", "./MCtemp/Install_Script.sh" ]
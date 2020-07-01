FROM fithwum/debian-base
MAINTAINER fithwum

# URL's for files
ARG INSTALL_SCRIPT=https://raw.githubusercontent.com/fithwum/minecraft/master/files/Install_Script.sh

# Install OpenJDK-11 & dependencies.
RUN apt-get update && apt-get -y install libstdc++ software-properties-common \
	&& apt-get install -y openjdk-11-jre-headless \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* \

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# folder creation.
RUN mkdir -p /MCserver /MCtemp \
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

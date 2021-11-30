FROM fithwum/debian-base:stretch
MAINTAINER fithwum

ENV ACCEPT_EULA="false"
ENV GAME_PORT=25565

# URL's for files
ARG INSTALL_SCRIPT=https://raw.githubusercontent.com/fithwum/minecraft/master/files/Install_Script.sh

# Install java8 & dependencies.
RUN apt-get -y update \
	&& apt-get install -y software-properties-common \
	&& wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add corretto.key \
	&& add-apt-repository 'deb https://apt.corretto.aws stable main' \
	&& apt-get -y update \
	&& apt-get install -y java-17-amazon-corretto-jdk ca-certificates-java \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*\
	&& update-ca-certificates -f;

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

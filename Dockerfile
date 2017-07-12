###############################################
# Ubuntu with added Teamspeak 3 Server.
# Uses SQLite Database on default.
###############################################

# Using latest Ubuntu image as base
FROM ubuntu:16.04

MAINTAINER Alex

RUN apt-get update \
        && apt-get install -y wget bzip2 --no-install-recommends \
        && rm -r /var/lib/apt/lists/*

## Set some variables for override.
# Download Link of TS3 Server
ENV TEAMSPEAK_VERSION 3.0.13.7
ENV TEAMSPEAK_SHA256 19ccd8db5427758d972a864b70d4a1263ebb9628fcc42c3de75ba87de105d179

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

# Download TS3 file and extract it into /opt.
RUN wget -O teamspeak3-server_linux-amd64.tar.bz2 http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux_amd64-${TEAMSPEAK_VERSION}.tar.bz2 \
        && echo "${TEAMSPEAK_SHA256} *teamspeak3-server_linux-amd64.tar.bz2" | sha256sum -c - \
        && tar -C /opt -xjf teamspeak3-server_linux-amd64.tar.bz2 \
        && rm teamspeak3-server_linux-amd64.tar.bz2

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/

CMD ["/opt/scripts/docker-ts3.sh"]

# Expose the Standard TS3 port, for files, for serverquery
EXPOSE 9987/udp 30033 10011

FROM openjdk:alpine
MAINTAINER Lauri Junkkari

ARG URL="http://ftb.cursecdn.com/FTB2/modpacks/FTBBeyond"
ARG VERSION="1_2_1"
ARG SERVER_FILE="FTBBeyondServer.zip"
ARG SERVER_PORT=25565

WORKDIR /minecraft

USER root
RUN adduser -D minecraft && \
    apk --no-cache add curl wget tmux && \
    mkdir -p /minecraft/world && \
    mkdir -p /minecraft/cfg && \
    mkdir -p /minecraft/backups &&\
    curl -SLO ${URL}/${VERSION}/FTBBeyondServer.zip  && \
    unzip ${SERVER_FILE} && \
    chmod u+x *.sh && \
    echo "eula=true" > /minecraft/eula.txt && \
    echo "[]" > /minecraft/cfg/ops.json && \
    echo "[]" > /minecraft/cfg/whitelist.json && \
    echo "[]" > /minecraft/cfg/banned-ips.json && \
    echo "[]" > /minecraft/cfg/banned-players.json && \
    echo "export JAVACMD=\"java\" \nexport MIN_RAM=\"2048M\" \nexport MAX_RAM=\"3072M\" \nexport PERMGEN_SIZE=\"256M\" \nexport JAVA_PARAMETERS=\"-XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=4 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10\"" > /minecraft/cfg/settings-local.sh && \
    ln -s /minecraft/cfg/ops.json /minecraft/ops.json && \
    ln -s /minecraft/cfg/whitelist.json /minecraft/whitelist.json && \
    ln -s /minecraft/cfg/banned-ips.json /minecraft/banned-ips.json && \
    ln -s /minecraft/cfg/banned-players.json /minecraft/banned-players.json && \
    ln -s /minecraft/cfg/settings-local.sh /minecraft/settings-local.sh && \
    chown -R minecraft:minecraft /minecraft

USER minecraft

RUN /minecraft/FTBInstall.sh

VOLUME ["/minecraft/world"]
VOLUME ["/minecraft/cfg"]
VOLUME ["/minecraft/backups"]

EXPOSE ${SERVER_PORT}

CMD ["/bin/sh", "/minecraft/ServerStart.sh"]

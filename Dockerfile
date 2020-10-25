FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Helsinki

# Install needed tools
RUN apt-get update && apt-get install -y \
    tzdata \
    default-jdk \
    git \
    curl

# Get Spigot BuildTools and create spigot.jar
RUN curl -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
# Following command fails, but BuildTools seem to be fine without.
# RUN git config --global --unset core.autocrlf
RUN java -jar BuildTools.jar --rev 1.16.3

# Create user
RUN useradd -u 1001 -ms /bin/bash minecraft
WORKDIR /home/minecraft

# Create application dir
RUN mkdir mc-server && chown minecraft:minecraft mc-server
WORKDIR /home/minecraft/mc-server
RUN mv /spigot-*.jar ./spigot.jar
COPY --chown=minecraft:minecraft eula.txt .
COPY --chown=minecraft:minecraft start.sh .
RUN chmod +x start.sh

# Create datadirectory mountpoints
RUN mkdir data && chown minecraft:minecraft data
RUN mkdir config-import && chown minecraft:minecraft config-import
RUN mkdir plugin-config-import && chown minecraft:minecraft plugin-config-import

# Import plugins
RUN mkdir plugins && chown minecraft:minecraft plugins
COPY --chown=minecraft:minecraft plugins/ plugins/

# Fetch plugins from internet
# ADD <url-to-jar> plugins/
# RUN chown minecraft:minecraft plugins/*

WORKDIR /home/minecraft/mc-server/data

# Connections to outer world
EXPOSE 25565

# Start server
ENTRYPOINT [ "/home/minecraft/mc-server/start.sh" ]

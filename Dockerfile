FROM ubuntu:focal

# Install needed tools
RUN apt-get update && apt-get install -y \
    default-jdk \
    git \
    curl

# Get Spigot BuildTools and create spigot.jar
RUN curl -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
# Following command fails, but BuildTools seem to be fine without.
# RUN git config --global --unset core.autocrlf
RUN java -jar BuildTools.jar --rev 1.15.2

# Create user
RUN useradd -ms /bin/bash minecraft
WORKDIR /home/minecraft

# Create application dir
RUN mkdir mc-server && chown minecraft:minecraft mc-server
WORKDIR /home/minecraf/mc-sever
RUN mv /spigot-*.jar spigot.jar
COPY --chown=minecraft:minecraft eula.txt ./
COPY --chown=minecraft:minecraft start.sh ./
RUN chmod +x start.sh

# Connections to outer world
EXPOSE 25565

# Start server
ENTRYPOINT [ "/home/minecraft/mc-server/start.sh" ]

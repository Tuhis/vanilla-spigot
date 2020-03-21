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

# Create application dir
RUN mkdir /mc-server
RUN cp spigot-*.jar /mc-server/spigot.jar
COPY eula.txt /mc-server/
COPY start.sh /mc-server/
RUN chmod 777 /mc-server/*

# Connections to outer world
EXPOSE 25565

# Start server
ENTRYPOINT [ "/mc-server/start.sh" ]

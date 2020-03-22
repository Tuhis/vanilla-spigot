#!/bin/sh

JAVA_XMX="${JAVA_XMX:-4G}"
JAVA_XMS="${JAVA_XMS:-4G}"
JAVA_OPTS="${JAVA_OPTS:--XX:+UseConcMarkSweepGC}"

cp ../eula.txt ./eula.txt
cp --remove-destination ../config-import/* ./
mkdir plugins
cp --remove-destination ../plugins/* plugins/

# TODO: Don't copy hidden files e.g. k8s ..data etc.
cp --remove-destination -r ../plugin-config-import/* plugins/

echo "Using JAVA_XMX: $JAVA_XMX"
echo "Using JAVA_XMS: $JAVA_XMS"
echo "Using JAVA_OPTS: $JAVA_OPTS"

java -Xms${JAVA_XMX} -Xmx${JAVA_XMS} ${JAVA_OPTS} -jar /home/minecraft/mc-server/spigot.jar

#!/bin/sh

_term() {
  echo "Caught SIGTERM signal!"
  kill "$child"
  wait "$child"
}

trap _term SIGTERM

JAVA_XMX="${JAVA_XMX:-4G}"
JAVA_XMS="${JAVA_XMS:-4G}"
JAVA_OPTS="${JAVA_OPTS:--XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200
-XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch
-XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M
-XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4
-XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90
-XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem
-XX:MaxTenuringThreshold=1}"

cp ../eula.txt ./eula.txt
cp --remove-destination ../config-import/* ./
mkdir plugins
cp --remove-destination ../plugins/* plugins/

# TODO: Don't copy hidden files e.g. k8s ..data etc.
cp --remove-destination -r ../plugin-config-import/* plugins/

echo "Using JAVA_XMX: $JAVA_XMX"
echo "Using JAVA_XMS: $JAVA_XMS"
echo "Using JAVA_OPTS: $JAVA_OPTS"

java -Xms${JAVA_XMX} -Xmx${JAVA_XMS} ${JAVA_OPTS} -jar /home/minecraft/mc-server/spigot.jar &

child=$!
wait "$child"

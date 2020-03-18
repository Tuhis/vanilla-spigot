#!/bin/sh

cd /mc-server
java -Xms4G -Xmx4G -XX:+UseConcMarkSweepGC -jar spigot.jar

#!/bin/bash

LS30_HOME="/usr/share/LS30"

# export PERLLIB=$LS30_HOME/lib

if [ -z "$LS30_SERVER" ];
then
	echo "WARNING: Undefined ENV variable \"LS30_SERVER\""
	LS30_SERVER=127.0.0.1:1681
fi

$LS30_HOME/bin/alarm-daemon.pl -h $LS30_SERVER 127.0.0.1:1681

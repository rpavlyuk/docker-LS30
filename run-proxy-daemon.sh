#!/bin/bash

LS30_HOME="/usr/share/LS30"

export PERLLIB=$LS30_HOME/lib

$LS30_HOME/bin/alarm-daemon.pl -h 192.168.1.220:1681 127.0.0.1:1681

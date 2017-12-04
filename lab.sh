#!/bin/bash

source bin/netkit.sh
source config/"$1".conf

start_lab
# TODO: Do something
sleep 30
stop_lab

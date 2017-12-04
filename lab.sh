#!/bin/bash

source bin/netkit.sh
source bin/remote.sh
source config/"$1".conf

start_lab

for TEST in "${@:2}"; do
  echo "Running test: $TEST"
  run_remote "root@$MANAGER" 'bash $PATH_TESTS'/"$TEST.sh"
done

stop_lab


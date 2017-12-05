#!/bin/bash

source bin/netkit.sh
source bin/remote.sh
source config/"$1".conf

case $2 in
  start) start_lab
  ;;
  stop) stop_lab
  ;;
  test)
    start_lab
    for TEST in "${@:3}"; do
      echo "Running test: $TEST"
      run_remote "root@$MANAGER" 'bash $PATH_TESTS'/"$TEST.sh"
    done
    stop_lab
  ;;
esac

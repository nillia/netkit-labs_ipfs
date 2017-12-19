#!/bin/bash

source bin/netkit.sh
source bin/remote.sh

import_lab(){
  if [ -d "labs/$1" ]; then
    source config/"$1".conf
  else
    echo "Cannot find lab: $1"
    echo "Availables: "
    cd labs && find * -prune -type d -exec echo "- "{} \; && cd --
    exit 1
   fi
}

import_lab "$2"

case $1 in
  start)
    start_lab
  ;;
  stop)
    stop_lab
  ;;
  test)
    for TEST in "${@:3}"; do
      echo "Running test: $TEST"
      run_remote "root@$MANAGER" 'bash $PATH_TESTS'/"$TEST.sh"
    done
  ;;
  *)
      echo "Usage: "
      echo "lab.sh [start | stop] lab_id"
      echo "lab.sh test lab_id test_id [test_id..]"
esac

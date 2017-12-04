#!/bin/bash

init_all_nodes(){
  for NODE in "${NODES[@]}"; do
	  run_remote $NODE "ipfs-init" &
  done

	sleep 5
}

stop_all_nodes(){
  for NODE in "${NODES[@]}"; do
	  run_remote $NODE "ipfs-stop"
  done
}

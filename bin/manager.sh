#!/bin/bash

init_all_nodes(){
  for NODE in "${NODES[@]}"; do
	  run_remote $NODE "ipfs-init $@" &
  done

	sleep 10
}

stop_all_nodes(){
  for NODE in "${NODES[@]}"; do
	  run_remote $NODE "ipfs-stop"
  done
}

get_node_addr(){
  run_remote "$1" ipfs id | grep "$1" | sed -e "s/[\",\,]//gi" -e "s/\s//gi"
}

remove_bootstrap(){
  for NODE in "${NODES[@]}"; do
	  run_remote $NODE "ipfs bootstrap rm --all" &
  done
}

get_stats(){
  run_remote $2 "ipfs stats bw" > stats_$1.txt
  run_remote $2 "ipfs stats repo" >> stats_$1.txt
  run_remote $2 "ipfs stats bitswap" >> stats_$1.txt
}

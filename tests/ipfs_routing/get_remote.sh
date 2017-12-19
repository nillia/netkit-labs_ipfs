#!/bin/bash

source /root/lab.conf
source $PATH_TESTS/bin/remote.sh
source $PATH_TESTS/bin/manager.sh

configure_routing(){
  NODE_1_ADDR=$(get_node_addr $NODE_1)
  NODE_2_ADDR=$(get_node_addr $NODE_2)

  run_remote $NODE_1 "ipfs bootstrap rm --all" > /dev/null
  run_remote $NODE_2 "ipfs bootstrap rm --all" > /dev/null
  run_remote $NODE_3 "ipfs bootstrap rm --all" > /dev/null

  run_remote $NODE_2 "ipfs swarm connect $NODE_1_ADDR"
  run_remote $NODE_3 "ipfs swarm connect $NODE_2_ADDR"
}

get_remote(){
  HASH=$(run_remote $NODE_1 "ipfs add quijote.txt.utf-8" | \
           grep "added" | cut -d " " -f 2)
  echo "File $HASH added to Node 1"

  echo "Downloading file: $HASH"
  run_remote $NODE_3 "ipfs cat $HASH > sample.txt"
  run_remote $NODE_3 "sha256sum sample.txt quijote.txt.utf-8"
}

init_all_nodes --init --disable-transport-encryption

configure_routing

get_stats r_gr_n1_pre $NODE_1
get_stats r_gr_n2_pre $NODE_2
get_stats r_gr_n3_pre $NODE_3

get_remote

get_stats r_gr_n1_post $NODE_1
get_stats r_gr_n2_post $NODE_2
get_stats r_gr_n3_post $NODE_3

stop_all_nodes

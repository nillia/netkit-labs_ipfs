#!/bin/bash

source /root/lab.conf
source $PATH_TESTS/bin/remote.sh
source $PATH_TESTS/bin/manager.sh

get_pinned_remote(){
  HASH=$(run_remote $NODE_1 "ipfs add quijote.txt.utf-8" | grep "added" | cut -d " " -f 2)
  echo "File $HASH added to Node 1"

  echo "Pinning file: $HASH"
  run_remote $NODE_2 "ipfs pin add $HASH"

  echo "Downloading file: $HASH"
  run_remote $NODE_3 "ipfs cat $HASH > sample.txt"
  run_remote $NODE_3 "sha256sum sample.txt quijote.txt.utf-8"
}

init_all_nodes --init --disable-transport-encryption

get_stats s_gpr_n1_pre $NODE_1
get_stats s_gpr_n2_pre $NODE_2
get_stats s_gpr_n3_pre $NODE_3

get_pinned_remote

get_stats s_gpr_n1_post $NODE_1
get_stats s_gpr_n2_post $NODE_2
get_stats s_gpr_n3_post $NODE_3

stop_all_nodes

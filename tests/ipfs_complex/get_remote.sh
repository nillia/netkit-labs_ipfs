#!/bin/bash

source /root/lab.conf
source $PATH_TESTS/bin/remote.sh
source $PATH_TESTS/bin/manager.sh

PEERS=($NODE_2 $NODE_3 $NODE_4 $NODE_5 $NODE_6 $NODE_7 $NODE_8)

configure_routing(){
  for NODE in "${NODES[@]}"; do
    echo "Cleaning routes for $NODE"
    run_remote $NODE "ipfs bootstrap rm --all" > /dev/null
  done

  for NODE in "${NODES[@]}"; do
    echo "Adding routes for $NODE"
    for NODE_X in "${NODES[@]}"; do
      NODE_X_ADDR=$(get_node_addr $NODE_X)
      run_remote $NODE "ipfs bootstrap add $NODE_X_ADDR" > /dev/null
    done
  done

  for NODE in "${NODES[@]}"; do
    wait_connections $NODE
  done
}

get_all_stats(){
  get_stats n1_$1 $NODE_1
  get_stats n2_$1 $NODE_2
  get_stats n3_$1 $NODE_3
  get_stats n4_$1 $NODE_4
  get_stats n5_$1 $NODE_5
  get_stats n6_$1 $NODE_6
  get_stats n7_$1 $NODE_7
  get_stats n8_$1 $NODE_8
}

wait_connections(){
  C=$(run_remote $1 ipfs swarm peers | cut -d "/" -f 3 | sort | uniq | wc -l)
  while [ $C -lt 7 ]; do
    echo "Esperando todas las conexiones para $1: $C"
    sleep 1
    C=$(run_remote $1 ipfs swarm peers | cut -d "/" -f 3 | sort | uniq | wc -l)
  done
}

init_all_nodes --init
configure_routing
HASH=$(run_remote $NODE_1 "ipfs add imagen.png" | \
         grep "added" | cut -d " " -f 2)
(time run_remote $NODE_3 "ipfs cat $HASH > copia.png") &> tiempo_descarga_simple.txt
run_remote $NODE_3 "sha256sum imagen.png copia.png"
get_all_stats post_remote
stop_all_nodes

sleep 5

init_all_nodes --init
configure_routing
HASH=$(run_remote $NODE_1 "ipfs add imagen.png" | \
         grep "added" | cut -d " " -f 2)
run_remote $NODE_3 "ipfs pin add $HASH"
get_all_stats post_pinning_2
stop_all_nodes
init_all_nodes
(time run_remote $NODE_6 "ipfs cat $HASH > copia.png") &> tiempo_descarga_pinning.txt
run_remote $NODE_6 "sha256sum imagen.png copia.png"
get_all_stats post_remote_2
stop_all_nodes

sleep 5

init_all_nodes --init
configure_routing
HASH=$(run_remote $NODE_1 "ipfs add imagen.png" | \
         grep "added" | cut -d " " -f 2)
run_remote $NODE_2 "ipfs pin add $HASH"
run_remote $NODE_3 "ipfs pin add $HASH"
run_remote $NODE_4 "ipfs pin add $HASH"
get_all_stats post_pinning_3
stop_all_nodes
init_all_nodes
(time run_remote $NODE_6 "ipfs cat $HASH > copia.png") &> tiempo_descarga_multiple_pinning.txt
run_remote $NODE_6 "sha256sum imagen.png copia.png"
get_all_stats post_remote_3
stop_all_nodes

sleep 5

init_tall_nodes --init
configure_routing
HASH=$(run_remote $NODE_1 "ipfs add imagen.png" | \
         grep "added" | cut -d " " -f 2)
time run_remote $NODE_2 "ipfs cat $HASH > copia.png"
run_remote $NODE_2 "sha256sum imagen.png copia.png"
time run_remote $NODE_3 "ipfs cat $HASH > copia.png"
run_remote $NODE_3 "sha256sum imagen.png copia.png"
time run_remote $NODE_4 "ipfs cat $HASH > copia.png"
run_remote $NODE_4 "sha256sum imagen.png copia.png"
get_all_stats post_remote_4
stop_all_nodes
init_all_nodes
(time run_remote $NODE_6 "ipfs cat $HASH > copia.png") &> tiempo_descarga_multiple_cache.txt
run_remote $NODE_6 "sha256sum imagen.png copia.png"
get_all_stats post_remote_4_2
stop_all_nodes

sleep 5

init_all_nodes --init
configure_routing
HASH=$(run_remote $NODE_1 "ipfs add imagen.png" | \
         grep "added" | cut -d " " -f 2)
time run_remote $NODE_2 "ipfs cat $HASH > copia.png"
run_remote $NODE_2 "sha256sum imagen.png copia.png"
get_all_stats post_remote_5
run_remote $NODE_1 "ipfs-stop"
(time run_remote $NODE_8 "ipfs cat $HASH > copia.png") > tiempo_descarga_cache.txt
run_remote $NODE_8 "sha256sum imagen.png copia.png"
get_all_stats post_remote_5_2
stop_all_nodes

for f in ./*_post_remote.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_remote.txt
for f in ./*_post_remote_2.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_remote_2.txt
for f in ./*_post_pinning_2.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_pinning_2.txt
for f in ./*_post_remote_3.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_remote_3.txt
for f in ./*_post_pinning_3.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_pinning_3.txt
for f in ./*_post_remote_4.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_remote_4.txt
for f in ./*_post_remote_4_2.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_remote_4_2.txt
for f in ./*_post_remote_5.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_remote_5.txt
for f in ./*_post_remote_5_2.txt; do echo $f >> out.txt; cat $f >> out.txt; echo >> out.txt; echo >> out.txt; done
mv out.txt post_remote_5_2.txt
rm stats*

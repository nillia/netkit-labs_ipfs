#!/bin/bash

source bin/deploy.sh
source config/ipfs_routing.conf

clear(){
  rm -rf $PATH_LAB/*.disk

  rm -rf $PATH_LAB/r1
  rm -rf $PATH_LAB/r2
  rm -rf $PATH_LAB/r3

  rm -rf $PATH_LAB/node1
  rm -rf $PATH_LAB/node2
  rm -rf $PATH_LAB/node3
  rm -rf $PATH_LAB/manager
}

deploy(){
  deploy_router r1
  deploy_router r2
  deploy_router r3

  deploy_node 1
  deploy_node 2
  deploy_node 3

  deploy_manager
}

case $1 in
  deploy) deploy
          ;;
  clear) clear
         ;;
esac

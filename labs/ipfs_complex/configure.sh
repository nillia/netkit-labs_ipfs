#!/bin/bash

source bin/deploy.sh
source config/ipfs_complex.conf

clear(){
  rm -rf $PATH_LAB/*.disk

  rm -rf $PATH_LAB/node1
  rm -rf $PATH_LAB/node2
  rm -rf $PATH_LAB/node3
  rm -rf $PATH_LAB/node4
  rm -rf $PATH_LAB/node5
  rm -rf $PATH_LAB/node6
  rm -rf $PATH_LAB/node7
  rm -rf $PATH_LAB/node8
  # rm -rf $PATH_LAB/node9
  # rm -rf $PATH_LAB/node10
  # rm -rf $PATH_LAB/node11
  # rm -rf $PATH_LAB/node12
  # rm -rf $PATH_LAB/node13
  # rm -rf $PATH_LAB/node14
  # rm -rf $PATH_LAB/node15
  # rm -rf $PATH_LAB/node16
  rm -rf $PATH_LAB/manager
}

deploy(){
  deploy_node 1
  deploy_node 2
  deploy_node 3
  deploy_node 4
  deploy_node 5
  deploy_node 6
  deploy_node 7
  deploy_node 8

  deploy_manager
}

case $1 in
  deploy) deploy
          ;;
  clear) clear
         ;;
esac

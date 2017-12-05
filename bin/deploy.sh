#!/bin.bash

deploy_node(){
  cp -r machines/node $PATH_LAB/node$1
}

deploy_manager(){
  cp -r machines/manager $PATH_LAB

  mkdir -p $PATH_LAB/manager/root
  cp config/$LAB_ID.conf $PATH_LAB/manager/root/lab.conf
  cp -r tests $PATH_LAB/manager/root/tests
  cp -r bin $PATH_LAB/manager/root/tests

  echo "export PATH_TESTS=/root/tests" >> $PATH_LAB/manager/root/.bashrc
  echo "source /root/lab.conf" >> $PATH_LAB/manager/root/.bashrc
  echo 'source $PATH_TESTS/bin/remote.sh' >> $PATH_LAB/manager/root/.bashrc
  echo 'source $PATH_TESTS/bin/manager.sh' >> $PATH_LAB/manager/root/.bashrc
}

deploy_router(){
  cp -r machines/router $PATH_LAB/$1
}

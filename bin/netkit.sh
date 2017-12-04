#!/bin/bash

start_lab(){
  bash $PATH_LAB/configure.sh deploy
  lstart -d $PATH_LAB -p -o --con0=none
}

stop_lab(){
  lhalt -d $PATH_LAB
  bash $PATH_LAB/configure.sh clear
}

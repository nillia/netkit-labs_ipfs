#!/bin/bash

run_remote(){
  #TODO: I dont know why the key auth scheme doesn't work in the netkit-fs
  #      This is a simple (ugly) workarround
	sshpass -p 1234 ssh -q $1 "${@:2}"
}

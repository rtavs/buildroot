#!/bin/bash

BUILDROOT=$(pwd)
TARGET=$1
NAME=$(whoami)
HOST=$(hostname)
DATETIME=`date +"%Y-%m-%d %H:%M:%S"`
#if [[ $ROOTFS_TYPE -eq "squashfs" ]]; then
	echo "# create ssh keys to $(pwd)/output/target/etc/ssh"
#	ssh-keygen -A -f $(pwd)/output/target/etc/ssh
#fi
echo "built by $NAME on $HOST at $DATETIME" > $TARGET/timestamp
exit 0

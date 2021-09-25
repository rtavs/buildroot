#!/usr/bin/env bash


BUILDROOT=$(pwd)
TARGET=$1
NAME=$(whoami)
HOST=$(hostname)
DATETIME=`date +"%Y-%m-%d %H:%M:%S"`

# install qemu-xxx-static
# cp /etc/resolv.conf
# mount proc/dev and chroot
# install package
# enable systemd service. (systemctl enable systemd-rootfs-resize)
# cleanup

arch_type()
{
	if grep -Eq "^BR2_aarch64=y$" ${BR2_CONFIG}; then
		echo "arm64"
	elif grep -Eq "^BR2_arm=y$" ${BR2_CONFIG}; then
		echo "armhf"
	fi
}

main()
{
	# $1 - the current rootfs directory, skeleton-custom or target
	echo $@
    echo arch=$(arch_type)

	echo "built by $NAME on $HOST at $DATETIME" > $TARGET/timestamp

	exit $?
}

main $@

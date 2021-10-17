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


echo $@
echo arch=$(arch_type)

echo "built by $NAME on $HOST at $DATETIME" > $TARGET/timestamp

#ln -srnf $TARGET/usr/share/zoneinfo/$(curl https://ipapi.co/timezone) $TARGET/etc/localtime


cat << EOF | proot -0 -q /usr/bin/qemu-aarch64-static -b /dev -b /proc -b /sys -r $TARGET

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C

#env

apt -y update
# apt -y upgrade
# apt install -f -y --no-install-recommends apt-utils inetutils-ping vim git net-tools
apt install -f -y --no-install-recommends systemd
apt clean
sync

EOF

exit $?

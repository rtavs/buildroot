#!/usr/bin/env bash


BUILDROOT=$(pwd)
DIRNAME=`dirname $0`
TARGET=$1
NAME=$(whoami)
HOST=$(hostname)
DATETIME=`date +"%Y-%m-%dT%H:%M:%S"`



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
echo $BUILDROOT
echo $DIRNAME
echo arch=$(arch_type)

echo "built $(git describe) by $NAME@$HOST at $DATETIME" > $TARGET/etc/build-id

#ln -srnf $TARGET/usr/share/zoneinfo/$(curl https://ipapi.co/timezone) $TARGET/etc/localtime


proot_run="proot \
	--qemu=/usr/bin/qemu-aarch64-static \
	--root-id \
	--kill-on-exit \
	--pwd=/root \
	--bind=/dev \
	--bind="/dev/urandom:/dev/random" \
	--bind="/dev/null:/dev/null" \
	--bind=/sys \
	--bind=/proc \
	--bind="/proc/self/fd:/dev/fd" \
	--bind="/proc/self/fd/1:/dev/stdout" \
	--bind="/proc/self/fd/2:/dev/stderr" \
	--bind="$DIRNAME/hooks:/root/hooks" \
	--rootfs=$TARGET"

echo proot_run=$proot_run

cat << EOF | $proot_run

export HOME=/root
#export LANG=C.UTF-8
export LC_ALL=C LANGUAGE=C LANG=C
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

apt -y update

echo "I: Install the dialog package and others first to squelch some warnings"
apt-get install -y dialog apt-utils
apt -y upgrade


# There are probably more packages in the following list than what is absolutely
# minimally necessary, but whatever you do don't get rid of systemd-sysv
# otherwise the system won't boot

echo "I: install systemd"
apt install -f -y --no-install-recommends systemd systemd-sysv sysvinit-utils

echo "I: install system base tools"
apt install -f -y --no-install-recommends \
	sudo udev rsyslog kmod vim-tiny \
	bash-completion


# Specify here if you'd like to use NetworkManager to configure network interfaces.
# It is recommended to set this to yes for two reasons:
#     1. Ethernet and wifi will work out of the box without any extra hoops to jump through.
#     2. If you plan to install a desktop environment then you'll be able to configure the network from the GUI.
# Use nmcli to connect to a wifi network from the terminal:
# $ nmcli device wifi rescan
# $ nmcli device wifi list
# $ nmcli device wifi connect MyWifiName password MyWifiPassword
# Replace MyWifiName and MyWifiPassword with your wifi network credentials.
# However, if you still prefer to use /etc/network/interfaces to configure your networking, then comment out this line.

echo "I: install network-manager"
apt install -f -y --no-install-recommends network-manager resolvconf

#apt install -f -y --no-install-recommends inetutils-ping git net-tools
#netbase dnsutils ifupdown isc-dhcp-client isc-dhcp-common less net-tools iproute2 iputils-ping libnss-mdns iw software-properties-common ethtool dmsetup hostname iptables logrotate lsb-base lsb-release plymouth psmisc tar tcpd usbutils wireless-regdb wireless-tools wpasupplicant ftp nano curl rsync build-essential telnet parted patch bash-completion linux-firmware


# if use NetworkManager
# Workaround for https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/1638842
# rm /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
# touch /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf


# use ttyS0 for serial console
rm -rf /etc/systemd/system/getty.target.wants/getty@ttyS0.service
ln -s /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyS0.service

apt clean

sync

EOF

for f in $DIRNAME/hooks/*.chroot; do
	echo "File -> $f"
	$proot_run /root/hooks/`basename $f`
done

exit $?

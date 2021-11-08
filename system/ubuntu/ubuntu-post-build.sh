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

# Install the dialog package and others first to squelch some warnings
apt-get -y install dialog apt-utils
apt -y upgrade

# There are probably more packages in the following list than what is absolutely
# minimally necessary, but whatever you do don't get rid of systemd-sysv otherwise the system won't boot
apt install -f -y --no-install-recommends systemd systemd-sysv sysvinit-utils

#apt-get -y install sudo udev rsyslog kmod util-linux sed language-pack-en netbase dnsutils ifupdown isc-dhcp-client isc-dhcp-common less vim net-tools iproute2 iputils-ping libnss-mdns iw software-properties-common ethtool dmsetup hostname iptables logrotate lsb-base lsb-release plymouth psmisc tar tcpd usbutils wireless-regdb wireless-tools wpasupplicant wget ftp nano curl rsync build-essential telnet parted patch bash-completion linux-firmware



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

#apt install -f -y --no-install-recommends network-manager resolvconf

#apt install -f -y --no-install-recommends inetutils-ping vim git net-tools

# User account setup
# useradd -s /bin/bash -G adm,sudo -m ${RPIUSER}
# Setting the password requires user input
# passwd ${RPIUSER}

# if use NetworkManager
# Workaround for https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/1638842
# rm /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
# touch /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf


# use ttyS0 for serial console
rm -rf /etc/systemd/system/getty.target.wants/getty@ttyS0.service
ln -s /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyS0.service

echo "root:root" | chpasswd

apt clean

sync

EOF

exit $?

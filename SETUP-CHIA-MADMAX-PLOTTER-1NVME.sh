#!/bin/bash

# Chia MadMax Plotter Setup
# By Rahim Khoja (rahim.khoja@alumni.ubc.ca)
# https://www.linkedin.com/in/rahim-khoja-879944139/

echo
echo -e "\033[0;31m░░░░░░░░▀▀▀██████▄▄▄"
echo "░░░░░░▄▄▄▄▄░░█████████▄ "
echo "░░░░░▀▀▀▀█████▌░▀▐▄░▀▐█ "
echo "░░░▀▀█████▄▄░▀██████▄██ "
echo "░░░▀▄▄▄▄▄░░▀▀█▄▀█════█▀"
echo "░░░░░░░░▀▀▀▄░░▀▀███░▀░░░░░░▄▄"
echo "░░░░░▄███▀▀██▄████████▄░▄▀▀▀██▌"
echo "░░░██▀▄▄▄██▀▄███▀▀▀▀████░░░░░▀█▄"
echo "▄▀▀▀▄██▄▀▀▌█████████████░░░░▌▄▄▀"
echo "▌░░░░▐▀████▐███████████▌"
echo "▀▄░░▄▀░░░▀▀██████████▀"
echo "░░▀▀░░░░░░▀▀█████████▀"
echo "░░░░░░░░▄▄██▀██████▀█"
echo "░░░░░░▄██▀░░░░░▀▀▀░░█"
echo "░░░░░▄█░░░░░░░░░░░░░▐▌"
echo "░▄▄▄▄█▌░░░░░░░░░░░░░░▀█▄▄▄▄▀▀▄"
echo -e "▌░░░░░▐░░░░░░░░░░░░░░░░▀▀▄▄▄▀\033[0m"
echo "---The Chia MadMax Plotter Setup Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               An NVME Drive for Plotting (Must not be boot disk)
#               /dev/sdb (a destination disk)
#               32 GB of Ram
#               Internet Access

# Stop on Error
set -eE  # same as: `set -o errexit -o errtrace`

# Failure Function
function failure() {
    local lineno=$1
    local msg=$2
    echo ""
    echo -e "\033[0;31mError at Line Number $lineno: '$msg'\033[0m"
    echo ""
}

# Failure Function Trap
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

# Check the bash shell script is being run by root/sudo
if [[ $EUID -ne 0 ]];
then
    echo "This script must be run with sudo" 1>&2
    exit 1
fi

# Update and Upgrade System
apt -y update
apt -y upgrade
apt -y install git
apt -y install python3
apt -y install python3-pip
apt -y install cmake
apt -y install libsodium-dev
apt -y install libgmp-dev
apy -y install openssh-server
apt -y install nfs-kernel-server 
apt -y install xfsprogs

# Disable Firewall
systemctl disable ufw

# Enable SSH Daemon
systemctl enable ssh

# Disable GUI
systemctl set-default multi-user

# Setup NVME as Plotting Disk
wipefs /dev/nvme0n1
(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/nvme0n1
mkfs.xfs -f /dev/nvme0n1p1
mkdir /mnt/plot || true
echo "/dev/nvme0n1p1   /mnt/plot       xfs    defaults        0       0" >> /etc/fstab
mount -a
chmod -R 777 /mnt/plot

# Create Logging Directory 
mkdir -p /var/log/chia-plotter || true
chmod -R 777 /var/log/chia-plotter

# Install Telegram-Send
pip3 install telegram-send

# Install Plotter Service
cp usr/local/bin/madmax-plot.sh /usr/local/bin/
chmod +x /usr/local/bin/madmax-plot.sh
cp etc/systemd/system/plotter.service /etc/systemd/system/

# Install Updated FSTrim Timer Service ( Hourly )
cp etc/systemd/system/timers.target.wants/ /etc/systemd/system/timers.target.wants/fstrim.timer

# Setup and Compile MadMax Chia Plotter
cd /usr/share
git clone https://github.com/madMAx43v3r/chia-plotter.git
cd /usr/share/chia-plotter
git submodule update --init
bash ./make_devel.sh
cp /usr/share/chia-plotter/build/chia_plot /usr/bin/

# Setup ZFS Disk
wipefs /dev/sdb
zpool create r0zfs1 /dev/sdb -f
chmod -R 777 /r0zfs1
zfs set sharenfs="on" r0zfs1

# Reload Systemd Daemons
systemctl daemon-reload

# Enable FSTrim Service
systemctl enable fstrim.timer

# Enable Plotter Service
systemctl enable plotter.service

# Reboot & Start Plotting
reboot

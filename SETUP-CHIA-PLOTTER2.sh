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
mkfs.ext4 -F /dev/nvme0n1p1
mkdir /mnt/plot || true
echo "/dev/nvme0n1p1   /mnt/plot       ext4    defaults        0       0" >> /etc/fstab
mount -a
chmod -R 777 /mnt/plot

# Install Telegram-Send
pip3 install telegram-send

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

# Create Logging Directory 
mkdir -p /var/log/chia-plotter
chmod -R 777 /var/log/chia-plotter

while true
do
    # Create Plot
    chia_plot a0226aee1c59ba9a70f9c4aab77ea662bce96766b58913dfff2fb48c5766d594d0430b38df7b5f9f1787d39d7ab310f6 9425d29b05b659d05814cd989e0d976c9b755f9730d3e112c8609aa3d5dd250a86ecb8c164a66861857d45e71d6c9b9a /mnt/plot/ /mnt/plot/ 29 7 2>&1 /var/log/chia-plotter/plotter.log

    # Sleep 10 Seconds
    sleep 10

    # Copy Plot to ZFS Disk & Delete Plot on NVME When Copied
    rsync -v --remove-source-files --info=progress2 /mnt/plot/*.plot /r0zfs1/ 2>&1 /var/log/chia-plotter/plotter.log
done


#!/bin/bash

# NVME Setup
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
echo "---NVME Setup Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               An NVME Drive for Plotting (Must not be boot disk)
#               XFS Tools Installed
#               NVME Device Name 'nvme0n1'

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

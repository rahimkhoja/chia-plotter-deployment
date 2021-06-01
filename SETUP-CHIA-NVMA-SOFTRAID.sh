#!/bin/bash

# NVME Soft Raid 0 for Chia Mining 
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
echo "---NVME Soft Raid 0 for Chia Mining Setup Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               Internet Access
#               (2) Two NVME Drives

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

# Get the user that ran the Script (Not Root)
baseuser=$(pstree -lu -s $$ | grep --max-count=1 -o '([^)]*)' | head -n 1 | sed 's/[()]//g') # Run commands in brackets and save output to variable`

# Setup NVME Soft Raid. (This uses two NVME drives, feel free to modify for your own needs)
# NVME Drives must show up as /dev/nvme0n1 and /dev/nvme1n1.

apt-get install -y mdadm
mdadm --zero-superblock /dev/nvme0n1
mdadm --zero-superblock /dev/nvme1n1
mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/nvme0n1 /dev/nvme1n1
mkfs.ext4 -F /dev/md0
mkdir -p /mnt/plot
mount /dev/md0 /mnt/plot/
mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
update-initramfs -u
echo '/dev/md0 /mnt/plot ext4 defaults,nofail 0 0' | tee -a /etc/fstab
cat /proc/mdstat
chmod -R 777 /mnt/plot/

# Setup FSTrim Timer for Hourly.
cp etc/systemd/system/timers.target.wants/fstrim.timer /etc/systemd/system/timers.target.wants/fstrim.timer
systemctl daemon-reload

# Enable FSTrim Timer
systemctl enable fstrim.timer

# Remount with FSTab
mount -a

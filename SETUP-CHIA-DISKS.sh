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

systemctl daemon-reload
systemctl enable fstrim.timer


wipefs /dev/sdb
wipefs /dev/sdc
wipefs /dev/sdd
wipefs /dev/sde
wipefs /dev/sdf
wipefs /dev/sdg
wipefs /dev/sdh
wipefs /dev/sdi
wipefs /dev/sdj
wipefs /dev/sdk
wipefs /dev/sdl

zpool create r0zfs1 /dev/sdb -f
zpool create r0zfs2 /dev/sdc -f
zpool create r0zfs3 /dev/sdd -f
zpool create r0zfs4 /dev/sde -f
zpool create r0zfs5 /dev/sdf -f
zpool create r0zfs6 /dev/sdg -f
zpool create r0zfs7 /dev/sdh -f
zpool create r0zfs8 /dev/sdi -f
zpool create r0zfs9 /dev/sdj -f
zpool create r0zfs10 /dev/sdk -f
zpool create r0zfs11 /dev/sdl -f

chmod -R 777 /r0zfs1
chmod -R 777 /r0zfs2
chmod -R 777 /r0zfs3
chmod -R 777 /r0zfs4
chmod -R 777 /r0zfs5
chmod -R 777 /r0zfs6
chmod -R 777 /r0zfs7
chmod -R 777 /r0zfs8
chmod -R 777 /r0zfs9
chmod -R 777 /r0zfs10
chmod -R 777 /r0zfs11

mkdir /r0zfs0
chmod -R 777 /r0zfs0

apt install nfs-kernel-server -y
zfs set sharenfs="on" r0zfs1
zfs set sharenfs="on" r0zfs2
zfs set sharenfs="on" r0zfs3
zfs set sharenfs="on" r0zfs4
zfs set sharenfs="on" r0zfs5
zfs set sharenfs="on" r0zfs6
zfs set sharenfs="on" r0zfs7
zfs set sharenfs="on" r0zfs8
zfs set sharenfs="on" r0zfs9
zfs set sharenfs="on" r0zfs10
zfs set sharenfs="on" r0zfs11

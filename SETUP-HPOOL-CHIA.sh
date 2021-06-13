#!/bin/bash

# HPOOL Miner Setup Script
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
echo "---HPOOL Miner Setup Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               Chia Plot Disk
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

# Remove Old Installation
rm -rf /usr/share/hpool || true
rm -f /etc/systemd/system/hpool-start.sh || true
rm -f /etc/systemd/system/hpool-timer.sh || true
rm -f /etc/systemd/system/hpool-restart.service || true
rm -f /etc/systemd/system/hpool-restart.timer || true
rm -f /etc/systemd/system/hpool.service || true

# Install Telegram-Send
pip3 install telegram-send

# Install HPool Service
cp usr/local/bin/hpool-start.sh /usr/local/bin/
chmod +x /usr/local/bin/hpool-start.sh
cp etc/systemd/system/hpool.service /etc/systemd/system/

# Install HPool Restart Service
cp usr/local/bin/hpool-timer.sh /usr/local/bin/
chmod +x /usr/local/bin/hpool-timer.sh
cp etc/systemd/system/hpool-restart.service /etc/systemd/system/
cp etc/systemd/system/hpool-restart.timer /etc/systemd/system/

# Crate HPool Log Dir
mkdir /var/log/HPool || true
chmod -R 777 /var/log/HPool

# Deploy HPool Chia Miner
mkdir /usr/share/hpool/ 
cd /usr/share/hpool/
wget https://github.com/hpool-dev/chia-miner/releases/download/v1.4.1-1/HPool-Miner-chia-v1.4.1-0-linux.zip
unzip ./HPool-Miner-chia-v1.4.1-0-linux.zip
chmod -R 777 /usr/share/hpool/*

# Reload Systemd Daemons
systemctl daemon-reload

# Enable HPool Service
systemctl enable hpool.service

# Enable HPool Restart Service
systemctl enable hpool-restart.service

# Enable HPool Restart timer
systemctl enable hpool-restart.timer

echo
echo "Install Complete"
echo
echo "Configure telegram-send 'sudo telegram-send'"
echo 
echo "Edit HPool Config 'sudo vi /usr/share/hpool/linux/config.yaml'"

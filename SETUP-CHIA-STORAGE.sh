#!/bin/bash

# Chia Full Node Setup
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
echo "---The Chia Full Node Setup Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               Internet Access
#               A SSD Boot Disk (Chia seems to need this) [It May be fine with 7200RPM+ Disk]

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

# Install Chia as Chia-Node User
cd /usr/share
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules
chmod -R 777 /usr/share/chia-blockchain
sudo -u storage -- sh -c "cd /usr/share/chia-blockchain; sh install.sh"

# Install Chia Gui as Plotter User
sudo -u storage -- sh -c "cd /usr/share/chia-blockchain;  . ./activate; sh install-gui.sh"

# Crate CHIA & Swar Log Dir
mkdir /var/log/chia || true
chmod -R 777 /var/log/chia

# Stop Chia Daemon
sudo -u storage -- sh -c "/usr/share/chia-blockchain/venv/bin/chia stop all -d" || true

echo "Chia Config File: /home/plotter/.chia/mainnet/config/config.yaml (Only Appears After 'chia init' Command is Run)"
echo "Chia Bin File: /usr/share/chia-blockchain/venv/bin/chia"
echo "Chia Bin Directory: /usr/share/chia-blockchain/venv/bin"
echo
echo
echo "Follow Guide Here Before Running SWAR: https://github.com/Chia-Network/chia-blockchain/wiki/Farming-on-many-machines"
echo

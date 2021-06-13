#!/bin/bash

# The Chia MadMax Plotter Update Script
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
echo "---The Chia MadMax Plotter Update Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               Internet Access
#               NVME Mounted at /mnt/plot
#               Previos Install of MadMax Plotter

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

# Create Logging Directory
mkdir -p /var/log/chia-plotter || true
chmod -R 777 /var/log/chia-plotter

# Install Telegram-Send
pip3 install telegram-send

# Remove Old Install
mv /usr/local/bin/madmax-plot.sh /usr/local/bin/madmax-plot.sh.bak || true
rm -f /etc/systemd/system/plotter.service || true
rm -rf /usr/share/chia-plotter || true

# Install Plotter Service
cp usr/local/bin/madmax-plot.sh /usr/local/bin/
chmod +x /usr/local/bin/madmax-plot.sh
cp etc/systemd/system/plotter.service /etc/systemd/system/

# Setup and Compile MadMax Chia Plotter
cd /usr/share
git clone https://github.com/madMAx43v3r/chia-plotter.git
cd /usr/share/chia-plotter
git submodule update --init
bash ./make_devel.sh
cp /usr/share/chia-plotter/build/chia_plot /usr/bin/

# Reload Systemd Daemons
systemctl daemon-reload

# Enable Plotter Service
systemctl enable plotter.service

num_cpus=$(nproc)

echo
echo "Deployment Successful"
echo
echo "You Have ${num_cpus} Threads Available for Plotting"
echo
echo "Please Edit /usr/local/bin/madmax-plot.sh and Add Your Farmer Key, Your Pool Key, and the Threads to be used by the Plotter"
echo
echo "Please Setup Telegram-Send 'sudo telegram-send'"
echo
echo "Reboot to start Auto Plotting"

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

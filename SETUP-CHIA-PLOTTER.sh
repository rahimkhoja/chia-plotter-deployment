#!/bin/bash

# Chia Swar Plotter Setup
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
echo "---The Chia Swar Plotter Setup Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               User plotter added to system
#               Internet Access
#               An NVME Drive for Plotting (Must not be boot disk)
#               A SSD Boot Disk (Chia seems to need this) [It May be fine with 7200RPM+ Disk]
#               The Main Wallet's CA (Shared by NFS is best)
#               The Plot Storage Location (NFS to Remote Storage is best)

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

# Install Chia as Plotter User
cd /usr/share
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules
chmod -R 777 /usr/share/chia-blockchain
sudo -u plotter -- sh -c "cd /usr/share/chia-blockchain; sh install.sh"

# Install Chia Gui as Plotter User
sudo -u plotter -- sh -c "cd /usr/share/chia-blockchain;  . ./activate; sh install-gui.sh"

# Install SWAR Plot Manager as Plotter User
cd /usr/share
git clone https://github.com/swar/Swar-Chia-Plot-Manager.git
chmod -R 777 /usr/share/Swar-Chia-Plot-Manager
sudo -u plotter -- sh -c "cd /usr/share/Swar-Chia-Plot-Manager; /usr/bin/pip3 install -r requirements.txt"

# Crate CHIA & Swar Log Dir
mkdir /var/log/chia || true
mkdir /var/log/swar || true
chmod -R 777 /var/log/chia
chmod -R 777 /var/log/swar

# Stop Chia Daemon
sudo -u plotter -- sh -c "/usr/share/chia-blockchain/venv/bin/chia stop all -d" || true


# Get System Info
# Get CPU (Threads)
num_cpus=$(nproc)
echo "Total Threads: ${num_cpus}"
max_parallel_cpu_plots=$(((${num_cpus}-1)/2))
echo "Max Possible parallel CPU Plots: ${max_parallel_cpu_plots}"
#!/bin/bash

# Chia Swar Plotter Setup
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
echo "---The Chia Swar Plotter Setup Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo

# Requirements: Ubuntu 20.04 LTS (Desktop Minimal)
#               User plotter added to system
#               Internet Access
#               An NVME Drive for Plotting (Must not be boot disk)
#               A SSD Boot Disk (Chia seems to need this) [It May be fine with 7200RPM+ Disk]
#               The Main Wallet's CA (Shared by NFS is best)
#               The Plot Storage Location (NFS to Remote Storage is best)

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

# Install Chia as Plotter User
cd /usr/share
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules
chmod -R 777 /usr/share/chia-blockchain
sudo -u plotter -- sh -c "cd /usr/share/chia-blockchain; sh install.sh"

# Install Chia Gui as Plotter User
sudo -u plotter -- sh -c "cd /usr/share/chia-blockchain;  . ./activate; sh install-gui.sh"

# Install SWAR Plot Manager as Plotter User
cd /usr/share
git clone https://github.com/swar/Swar-Chia-Plot-Manager.git
chmod -R 777 /usr/share/Swar-Chia-Plot-Manager
sudo -u plotter -- sh -c "cd /usr/share/Swar-Chia-Plot-Manager; /usr/bin/pip3 install -r requirements.txt"

cp /usr/share/Swar-Chia-Plot-Manager/config.yaml.default /usr/share/Swar-Chia-Plot-Manager/config.yaml

# Crate CHIA & Swar Log Dir
mkdir /var/log/chia || true
mkdir /var/log/swar || true
chmod -R 777 /var/log/chia
chmod -R 777 /var/log/swar

# Stop Chia Daemon
sudo -u plotter -- sh -c "/usr/share/chia-blockchain/venv/bin/chia stop all -d" || true


# Get System Info
# Get CPU (Threads)
num_cpus=$(nproc)
echo "Total Threads: ${num_cpus}"
max_parallel_cpu_plots=$(((${num_cpus}-1)/2))
echo "Max Possible parallel CPU Plots: ${max_parallel_cpu_plots}"
# Get Total Memory 
mem_kb=$(grep MemTotal /proc/meminfo | awk {'print $2'})
mem_mb=$((${mem_kb}/1024))
max_parallel_memory_plots=$(((${mem_mb}-1024)/3500))
echo "Memory in KB: ${mem_kb}"
echo "Memory in MB: ${mem_mb}"
echo "Max Possible parallel Memory Plots: ${max_parallel_memory_plots}"

# Get NVME Size
nvme_b=$(lsblk -b -no SIZE /dev/nvme0n1p1)
nvme_kb=$((${nvme_b}/1024))
nvme_mb=$((${nvme_kb}/1024))
nvme_gb=$((${nvme_mb}/1024))
echo "Total NVME Space in GB: ${nvme_gb}"
max_parallel_nvme_plots=$((${nvme_gb}/380))
echo "Max Possible parallel NVME Plots: ${max_parallel_nvme_plots}"

# Check NVME for Max Plot Restriction
if [[ ( "${max_parallel_nvme_plots}" -lt "${max_parallel_memory_plots}" && "${max_parallel_nvme_plots}" -lt ${max_parallel_cpu_plots} ) ]]; then
        max_plots="${max_parallel_nvme_plots}"
fi

# Check Memory for Max Plot Restriction
if [[ ( "${max_parallel_memory_plots}" -lt "${max_parallel_nvme_plots}" && "${max_parallel_memory_plots}" -lt ${max_parallel_cpu_plots} ) ]]; then
        max_plots="${max_parallel_memory_plots}"
fi

if [[ ( "${max_parallel_cpu_plots}" -lt "${max_parallel_memory_plots}" && "${max_parallel_cpu_plots}" -lt ${max_parallel_nvme_plots} ) ]]; then
        max_plots="${max_parallel_cpu_plots}"
fi

echo
echo "Max Parallel Plots on System: ${max_plots}"
echo

echo "Setting Up Defauls in Swar Config File (You still need to update it)"
sed -i '/^chia_location:/c\chia_location: /usr/share/chia-blockchain/venv/bin/chia' /usr/share/Swar-Chia-Plot-Manager/config.yaml
sed -i '/^  folder_path:/c\  folder_path: /var/log/swar' /usr/share/Swar-Chia-Plot-Manager/config.yaml
sed -i "/^  max_concurrent:/c\  max_concurrent: ${max_plots}" /usr/share/Swar-Chia-Plot-Manager/config.yaml

echo
echo "The Chia Plotters Need a Farm/Ploter Key in the config File"
echo "The Chia Blockchain needs Access to the Main Wallet's CA/SSL/TLS directory"
echo 
echo "Chia Config File: /home/plotter/.chia/mainnet/config/config.yaml (Only Appears After 'chia init' Command is Run)"
echo "Swar Config File: /usr/share/Swar-Chia-Plot-Manager/config.yaml"
echo "Chia Bin File: /usr/share/chia-blockchain/venv/bin/chia"
echo "Chia Bin Directory: /usr/share/chia-blockchain/venv/bin" 
echo 
echo 
echo "Follow Guide Here Before Running SWAR: https://github.com/Chia-Network/chia-blockchain/wiki/Farming-on-many-machines"
echo 
echo "Make sure all Config files and CA files are readable by the \`plotter\` user"
echo "Command to Start The Harvestor: /usr/share/chia-blockchain/venv/bin/chia start harvester -r"
echo
echo "Update Chia Logging Directory in \`/home/plotter/.chia/mainnet/config/config.yaml\` with this location \`/var/log/chia/chia.log\`"

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

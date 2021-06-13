service swar-watch stop
service harvester-watch stop
systemctl disable swar-watch
systemctl disable harvester-watch
umount /mnt/plot
mdadm --stop /dev/md0
mdadm --remove /dev/md0
mdadm --zero-superblock /dev/nvme0n1 /dev/nvme1n1
rm -f /etc/mdadm/mdadm.conf
apt remove mdadm -y
vi /etc/fstab

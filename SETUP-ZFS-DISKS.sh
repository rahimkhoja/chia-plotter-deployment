
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

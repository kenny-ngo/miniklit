# Add extensions
set -x

# format harddisk
echo -e 'n\np\n1\n\n\na\n1\nw' | sudo fdisk -H16 -S32 /dev/sda
sudo mkfs.ext2 /dev/sda1


# copy system to harddisk
sudo mkdir /mnt/sda1
sudo mount /dev/sda1 /mnt/sda1
sudo mount /mnt/sr0
sudo cp -a /mnt/sr0/boot /mnt/sda1/
sudo umount /mnt/sr0

# modify bootloader config
sudo mv /mnt/sda1/boot/isolinux /mnt/sda1/boot/extlinux
cd /mnt/sda1/boot/extlinux
sudo rm boot.cat isolinux.bin
sudo mv isolinux.cfg extlinux.conf
sudo sed -i -e '/append / s/$/ user=klit opt=sda1 home=sda1/' -e 's/timeout .*/timeout 1/' extlinux.conf
cd


# install 32-bit libraries
. /etc/init.d/tc-functions
getMirror
MIRROR32=`echo $MIRROR | sed 's/x86_64/x86/'`
cd /tmp
wget `echo $MIRROR32 | sed 's/tcz$/release\/Core-current.iso/'`
sudo mount -o loop Core-current.iso /mnt/sr0
zcat /mnt/sr0/boot/core.gz | sudo cpio -id "lib/l*"
sudo ln -s /tmp/lib/ld-linux.so* /lib
sudo umount /mnt/sr0
rm Core-current.iso
echo /tmp/lib >> /etc/ld.so.conf
sudo ldconfig
cd

# install 32-bit syslinux
wget -P /tmp $MIRROR32/syslinux.tcz
tce-load -i /tmp/syslinux.tcz


# make disk bootable
sudo sh -c 'cat /usr/local/share/syslinux/mbr.bin > /dev/sda'
sudo /usr/local/sbin/extlinux --install /mnt/sda1/boot/extlinux

# create extensions directory
sudo mkdir /mnt/sda1/tce
sudo mkdir -p /mnt/sda1/tce/optional/
sudo chgrp -R staff /mnt/sda1/tce
sudo chmod -R 775 /mnt/sda1/tce

# change tcedir to harddisk
mv /etc/sysconfig/tcedir /etc/sysconfig/tcedir.bak
ln -s /mnt/sda1/tce /etc/sysconfig/tcedir
rm -rf /usr/local/tce.installed/*

mv /home/*/*.tcz* /mnt/sda1/tce/optional/


tce-load -wi ipv6-`uname -r` iptables iproute2

# Prepare additional packages
echo "/usr/local/etc/init.d/openssh start 2>&1 >/dev/null" >> /opt/bootlocal.sh
sudo rm /usr/local/tce.installed/openssh
tce-load -wi openssh
tce-load -wi bash
tce-load -wi nginx
tce-load -wi libxml2
tce-load -wi openssl
tce-load -wi pcre
tce-load -wi curl
tce-load -wi libpng
tce-load -wi freetype
tce-load -wi gmp
tce-load -wi icu
tce-load -wi expat2

# base system modifications
sudo sed -i -e '/^\/opt\/bootlocal/i' /opt/bootsync.sh
echo 'etc/issue' >> /opt/.filetool.lst
echo 'etc/shadow' >> /opt/.filetool.lst
echo 'usr/local/etc' >> /opt/.filetool.lst

# save changes
rm -f .ash_history
filetool.sh -b sda1

exit 0

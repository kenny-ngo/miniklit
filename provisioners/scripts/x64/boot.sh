####
# x64/boot.sh
# Kenny Ngo - 03/25/2016
####

set -x
####
# Format harddisk
####
echo -e 'n\np\n1\n\n\na\n1\nw' | sudo fdisk -H16 -S32 /dev/sda
sudo mkfs.ext2 /dev/sda1

####
# Copy system to harddisk
####
sudo mkdir /mnt/sda1
sudo mount /dev/sda1 /mnt/sda1
sudo mount /mnt/sr0
sudo cp -a /mnt/sr0/boot /mnt/sda1/
sudo umount /mnt/sr0

####
# Modify bootloader config
####
sudo mv /mnt/sda1/boot/isolinux /mnt/sda1/boot/extlinux
cd /mnt/sda1/boot/extlinux
sudo rm boot.cat isolinux.bin
sudo mv isolinux.cfg extlinux.conf
sudo sed -i -e '/append / s/$/ user=klit opt=sda1 home=sda1 host=core64/' -e 's/timeout .*/timeout 1/' extlinux.conf
cd

####
# Install 32-bit libraries
####
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

####
# Install 32-bit syslinux
####
wget -P /tmp $MIRROR32/syslinux.tcz
tce-load -i /tmp/syslinux.tcz

####
# Create extensions directory
####
sudo mkdir /mnt/sda1/tce
sudo mkdir -p /mnt/sda1/tce/optional/
sudo chgrp -R staff /mnt/sda1/tce
sudo chmod -R 775 /mnt/sda1/tce

####
# Change tcedir to harddisk
####
mv /etc/sysconfig/tcedir /etc/sysconfig/tcedir.bak
ln -s /mnt/sda1/tce /etc/sysconfig/tcedir
rm -rf /usr/local/tce.installed/*
tce-load -wi ipv6-`uname -r` iptables iproute2


####
# Sanity scripts / configuration files
####
find /home/klit/ \( -name "*.ini" -o -name "*.sh" -o -name "*.txt" -o -name "*.cnf"\) -exec dos2unix {} \;


####
# Validate the packages
####
cd
md5sum *.tcz* > md5sum.check
diff md5sum md5sum.check >/dev/null
if [ $? -ne 0 ]
then
   echo "Extensions are corrupted"
   exit 1
fi


####
# Merge large local extensions
# GitHub only allow Max < 100mb
####
for i in /home/klit/*.tcz.p1
do
   name=`basename ${i} | sed 's/\.p1//'`
   filename=`echo ${i} | sed 's/\.p[0-9]\+$//'`
   cat ${filename}.p* > ${filename}
   rm ${filename}.p*
done

####
# Truncate validate.sh
####
> /opt/validate.sh

####
# Install local extensions
####
for i in /home/klit/*.tcz
do
   # name=`echo $i | sed 's/.*\///'`
   name=`basename ${i}`
   md5sum "${i}" > "/mnt/sda1/tce/optional/${name}.md5.txt"
   mv "${i}" /mnt/sda1/tce/optional/
   echo "${name}" >> /mnt/sda1/tce/onboot.lst
done

####
# Prepare additional packages
####
echo "/usr/local/etc/init.d/openssh start 2>&1 >/dev/null" >> /opt/bootlocal.sh
sudo rm /usr/local/tce.installed/openssh
tce-load -wi openssh

####
# Enable 4GB of SWAP
####
dd if=/dev/zero of=/mnt/sda1/miniklit.swp bs=1024 count=4096000
chmod 0600 /mnt/sda1/miniklit.swp
mkswap /mnt/sda1/miniklit.swp
echo "swapon /mnt/sda1/miniklit.swp" >> /opt/bootlocal.sh

####
# Deploy Control Script
####
mv /home/klit/miniklit.sh /opt/miniklit/miniklit.sh
chmod a+x /opt/miniklit/miniklit.sh

for package in `cat /home/klit/packages.txt`
do
   tce-load -wi $package
   echo "tce-load -wi $package" >> /opt/validate.sh
done

####
# Base system modifications
####
sudo sed -i -e '/^\/opt\/bootlocal/i' /opt/bootsync.sh
echo 'etc/issue' >> /opt/.filetool.lst
echo 'etc/shadow' >> /opt/.filetool.lst
echo 'usr/local/etc' >> /opt/.filetool.lst

####
# Always save data
####
echo 'filetool.sh -b sda1' >> /opt/shutdown.sh

####
# Make disk bootable
####
sudo sh -c 'cat /usr/local/share/syslinux/mbr.bin > /dev/sda'
sudo /usr/local/sbin/extlinux --install /mnt/sda1/boot/extlinux

####
# Save changes
####
rm -f .ash_history
filetool.sh -b sda1

exit 0

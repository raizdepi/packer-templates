
set -xe

###
# vmware tools

cd /tmp
apt-get install -y fuse-utils
mkdir -p /mnt/cdrom
mount -o loop /home/vagrant/linux.iso /mnt/cdrom
tar zxvf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/

# Fix vmhgfs
cd /tmp/vmware-tools-distrib/lib/modules/source
tar xf vmhgfs.tar
if grep -q d_u.d_alias vmhgfs-only/inode.c; then
  echo "already patched"
else
  sed -i -e s/d_alias/d_u.d_alias/ vmhgfs-only/inode.c
  cp -p vmhgfs.tar vmhgfs.tar.orig
  tar cf vmhgfs.tar vmhgfs-only
fi

/tmp/vmware-tools-distrib/vmware-install.pl -d
rm /home/vagrant/linux.iso
umount /mnt/cdrom

sed -i.bak 's/answer AUTO_KMODS_ENABLED_ANSWER no/answer AUTO_KMODS_ENABLED_ANSWER yes/g' /etc/vmware-tools/locations
sed -i.bak 's/answer AUTO_KMODS_ENABLED no/answer AUTO_KMODS_ENABLED yes/g' /etc/vmware-tools/locations

echo "vmhgfs" >> /etc/modules

###
# open-vm-tools
#apt-get install -y open-vm-tools


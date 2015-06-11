# exit in error
set -e

cd /tmp
apt-get install -y fuse-libs
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

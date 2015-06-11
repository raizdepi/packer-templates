set -e

# Set up Vagrant.

date > /etc/vagrant_box_build_time

# Create the user vagrant with password vagrant
if ! getent passwd vagrant >/dev/null >&2;then
    useradd -G sudo -p $(perl -e'print crypt("vagrant", "vagrant")') -m -s /bin/bash -N vagrant
fi

# Install vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
curl -Lo /home/vagrant/.ssh/authorized_keys \
  'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /var/run/motd

# Install NFS client
if [ -f /etc/debian_release ]; then
    apt-get -y install nfs-common
elif [ -f /etc/redhat-release ]; then
    yum install -y nfs-utils nfs-utils-lib
fi

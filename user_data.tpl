#!/bin/bash
# Set hostname
HOSTNAME=${hostname}
FQDN=${fqdn}
hostname $HOSTNAME
echo "127.0.0.1 $FQDN $HOSTNAME" >> /etc/hosts
sed -i "s/^\(HOSTNAME=\).*$/\1$FQDN/" /etc/sysconfig/network

# Salt repo
rpm --import https://repo.saltstack.com/yum/redhat/6/x86_64/latest/SALTSTACK-GPG-KEY.pub
cat >/etc/yum.repos.d/saltstack.repo <<EOS
[saltstack-repo]
name=SaltStack repo for RHEL/CentOS 6
baseurl=https://repo.saltstack.com/yum/redhat/6/\$basearch/latest
enabled=1
gpgcheck=1
gpgkey=https://repo.saltstack.com/yum/redhat/6/\$basearch/latest/SALTSTACK-GPG-KEY.pub
EOS

# Full update
yum clean expire-cache
yum -y update

# Salt minion
yum -y install salt-minion

mkdir -p /etc/salt/minion.d
echo "master: ${salt_master}" > /etc/salt/minion.d/master.conf
cat >/etc/salt/minion.d/grains.conf <<EOS
grains:
  roles:
    - ${role}
  saltenv: ${env}
EOS

chkconfig salt-minion on
service salt-minion start

salt-call state.highstate
salt-call state.highstate
salt-call state.highstate

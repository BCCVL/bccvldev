#!/bin/sh

/usr/sbin/sshd-keygen


# COPY pub keys from /etc/opt/zope/zope.id_rsa.pub to /opt/zope/.ssh/authorized_keys to ensure correct permissions

mkdir -p $Z_HOME/.ssh
cp $Z_CONF/zope.id_rsa.pub $Z_HOME/.ssh/authorized_keys

chown -R zope:zope $Z_HOME
chmod 500 $Z_HOME/.ssh
chmod 600 $Z_HOME/.ssh/*

exec /usr/sbin/sshd -D -e

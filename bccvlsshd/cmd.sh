#!/bin/sh

/usr/sbin/sshd-keygen


# COPY pub keys from /etc/opt/zope/zope.id_rsa.pub to /opt/zope/.ssh/authorized_keys to ensure correct permissions

mkdir -p ${BCCVL_HOME}/.ssh
cp ${BCCVL_ETC}/ssh/${BCCVL_USER}.id_rsa.pub ${BCCVL_HOME}/.ssh/authorized_keys

chown -R ${BCCVL_USER}:${BCCVL_USER} ${BCCVL_HOME}
chmod 500 ${BCCVL_HOME}/.ssh
chmod 600 ${BCCVL_HOME}/.ssh/*

exec /usr/sbin/sshd -D -e

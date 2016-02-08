#!/bin/sh

/usr/sbin/sshd-keygen

exec /usr/sbin/sshd -D -e

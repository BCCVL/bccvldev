#!/bin/sh

docker run --rm -it --net bccvldev_bccvlnet busybox telnet "$@"

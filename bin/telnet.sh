#!/bin/sh

# usage: ./bin/telnet.sh <containername> <port>

docker run --rm -it --net bccvldev_bccvlnet busybox telnet "$@"

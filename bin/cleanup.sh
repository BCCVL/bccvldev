#!/bin/sh

# remove all stopped conatiners
docker rm $(docker ps -a -q -f status=exited)

# delete all untagged/dangling images
docker rmi $(docker images -q -f dangling=true)

# remove dangling volumes
docker volume rm $(docker volume ls -qf dangling=true)


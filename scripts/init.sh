#!/bin/bash

docker exec rabbitmq rabbitmqctl add_vhost bccvl
docker exec rabbitmq rabbitmqctl add_user bccvl bccvl
docker exec rabbitmq rabbitmqctl set_permissions -p bccvl bccvl '.*' '.*' '.*'
docker exec rabbitmq rabbitmqctl set_permissions -p bccvl admin '.*' '.*' '.*'

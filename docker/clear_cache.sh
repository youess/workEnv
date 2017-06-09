#!/bin/bash


docker rm -f $(docker ps -aq)
docker rmi $(docker images | grep '<none>' | awk '{print $3}')

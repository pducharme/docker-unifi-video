#!/bin/bash

BASEDIR=~/Applications/unifi-video
IP=127.0.0.1

NAME=unifi-video
VERSION=v3.4.0

# Run docker once to create a container and return the ID
# For following startups, use 'docker start <containerID>'

CONTAINER=`docker ps -a --filter ancestor=exsilium/unifi-video:$VERSION --format "{{.ID}}"`

if [ ! -z $CONTAINER ]
then
  echo "There seems to be an existing container with the ancestor image. Please use 'docker start <containerID> to start it."
  docker ps -a --filter ancestor=exsilium/unifi-video:$VERSION --format "table {{.ID}}\t{{.Names}}\t{{.CreatedAt}}\t{{.Status}}"
  echo "==> Exiting without doing anything!"
else
  printf "Checking for Host data volumes: MongoDB-"
  if [ -d $BASEDIR/mongodb ]
  then
    printf "OK"
  else
    printf "NOK\n"
    echo "Please make sure you have created the following directory: $BASEDIR/mongodb"
    exit 1;
  fi
  printf " | Unifi-Video-"
  if [ -d $BASEDIR/unifi-video ]
  then
    printf "OK"
  else
    printf "NOK\n"
    echo "Please make sure you have created the following directory: $BASEDIR/unifi-video"
    exit 1;
  fi
  printf " | Log-"
  if [ -d $BASEDIR/log ]
  then
    printf "OK"
  else
    printf "NOK\n"
    echo "Please make sure you have created the following directory: $BASEDIR/log"
    exit 1;
  fi
  printf "\n"
  docker run -d --privileged \
  -v $BASEDIR/mongodb:/var/lib/mongodb \
  -v $BASEDIR/unifi-video:/var/lib/unifi-video \
  -v $BASEDIR/log:/var/log/unifi-video \
  -p $IP:6666:6666 \
  -p $IP:7080:7080 \
  -p $IP:7443:7443 \
  --name $NAME \
  exsilium/unifi-video:$VERSION
fi
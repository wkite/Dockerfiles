#!/bin/bash
set -ex
DEBUG=${DEBUG:-false}
DIRNAME=$(dirname $(readlink -f $0))
NAME=$(basename $DIRNAME)
RUN_AFTER_BUILD=${RUN_AFTER_BUILD:-true}
ENTER_ENV=${ENTER_ENV:-false}

PORT=${1:-1812}
SPEEDER_PORT=$(($PORT + 1))
NUM=${NUM:-2}
GAME_MODE=${GAME_MODE:-false}
FEC=${FEC:-10:10}

docker build --build-arg DEBUG=${DEBUG} -t $NAME $DIRNAME
docker ps -a | grep "$NAME " | while read ID ignore; do docker stop $ID; docker rm $ID; done
docker images | grep '<none>' | while read NAME TAG IMG_ID ignore; do
  docker ps -a | grep $IMG_ID | while read ID ignore; do docker stop $ID; docker rm $ID; done
  docker rmi $IMG_ID
done

if $RUN_AFTER_BUILD; then
  docker run -d --name $PORT --restart=always --cap-add NET_ADMIN \
    -e PORT=$PORT -e NUM=$NUM -e GAME_MODE=$GAME_MODE -e FEC=$FEC \
    -p $PORT:51820/udp -p $SPEEDER_PORT:51821/udp -v /mnt/wgkey:/mnt/wgkey $NAME
  sleep 2 && docker logs $PORT
fi

if ! $ENTER_ENV; then
  echo docker exec -it $PORT /bin/sh
  exit 0
fi
exec docker exec -it $PORT /bin/sh


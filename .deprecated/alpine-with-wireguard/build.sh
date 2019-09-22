#!/bin/bash
set -ex
DEBUG=${DEBUG:-false}
DIRNAME=$(dirname $(readlink -f $0))
NAME=$(basename $DIRNAME)
RUN_AFTER_BUILD=${RUN_AFTER_BUILD:-true}
ENTER_ENV=${ENTER_ENV:-false}

PORT=${1:-7000}
NUM=${NUM:-2}
GAME_MODE=${GAME_MODE:-false}
FEC=${FEC:-10:10}

docker build --build-arg DEBUG=${DEBUG} -t $NAME $DIRNAME
docker ps -a | grep " $NAME" | awk '{print$1}' | xargs docker stop || true
docker ps -a | grep " $NAME" | awk '{print$1}' | xargs docker rm || true
docker images | grep '<none>' | awk '{print$3}' | xargs docker rmi || true

if $RUN_AFTER_BUILD; then
  docker run -d --name $NAME-$PORT --restart=always --cap-add NET_ADMIN -e PORT=$PORT -e NUM=$NUM -p $PORT:51820/udp -v /mnt/wgkey:/mnt/wgkey $NAME
  sleep 2 && docker logs $NAME-$PORT
fi

if $ENTER_ENV; then
  docker exec -it $NAME-$PORT /bin/sh
else
  echo docker exec -it $NAME-$PORT /bin/sh
fi

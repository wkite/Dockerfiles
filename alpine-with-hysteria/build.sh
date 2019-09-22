#!/bin/bash
set -ex
DEBUG=${DEBUG:-false}
DIRNAME=$(dirname $(readlink -f $0))
NAME=$(basename $DIRNAME)
RUN_AFTER_BUILD=${RUN_AFTER_BUILD:-true}
ENTER_ENV=${ENTER_ENV:-false}

PORT=${1:-7000}

docker build --build-arg DEBUG=${DEBUG} -t $NAME $DIRNAME
docker ps -a | grep "$NAME " | while read ID ignore; do docker stop $ID; docker rm $ID; done
docker images | grep '<none>' | while read NAME TAG IMG_ID ignore; do
  docker ps -a | grep $IMG_ID | while read ID ignore; do docker stop $ID; docker rm $ID; done
  docker rmi $IMG_ID
done

if $RUN_AFTER_BUILD; then
  docker run -d --name $PORT -e PASSWORD=$(uuidgen) -p $PORT:7000/udp $NAME
  sleep 1 && docker logs $PORT
fi

set -ex
if ! $ENTER_ENV; then
  echo docker exec -it $PORT sh
  exit 0
fi
exec docker exec -it $PORT sh

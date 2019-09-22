#!/bin/bash
set -ex
DEBUG=${DEBUG:-false}
NAME=$(basename $PWD)
PORT=${PORT:-8080}
ENTER_ENV=${ENTER_ENV:-true}
PASSWORD=${PASSWORD:-defaultmima}
EXTRASPORT=$(($PORT + 1))

docker build --build-arg DEBUG=${DEBUG} -t $NAME:$PORT .

docker stop $NAME-$PORT || true
docker rm $NAME-$PORT || true
docker images  | grep '<none>' | awk '{print$3}'| while read ID; do echo "docker rmi $ID"; docker rmi $ID; done

docker run -d --name $NAME-$PORT --init --restart=always -e USERNAME=admin -e PASSWORD=$PASSWORD -e SS_PASSWORD=$PASSWORD -e KCP_ENCRYPT=none -e KCP_PASSWORD=none-encrypt -p $PORT:80/tcp -p $EXTRASPORT:29900/udp $NAME:$PORT

sleep 1 && docker logs $NAME-$PORT

if $ENTER_ENV; then
  docker exec -it $NAME-$PORT /bin/sh
fi

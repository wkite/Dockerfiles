#!/bin/bash
set -ex
DEBUG=${DEBUG:-false}
NAME=$(basename $PWD)
PORT=${PORT:-1194}
ENTER_ENV=${ENTER_ENV:-true}
PASSWORD=${PASSWORD:-defaultmima}
BIN=$(ls /usr/share/easy-rsa/3*/easyrsa | head -1 || true)

if [[ ! -f $BIN ]]; then
  yum -y -q install easy-rsa
  BIN=$(ls /usr/share/easy-rsa/3*/easyrsa | head -1 || true)
fi

if [[ ! -f server/dh.pem ]]; then
  cat << EOF > vars
set_var EASYRSA_REQ_COUNTRY "US"
set_var EASYRSA_REQ_PROVINCE "New York"
set_var EASYRSA_REQ_CITY "New York"
set_var EASYRSA_REQ_ORG "UN"
set_var EASYRSA_REQ_OU "Anonymous"
set_var EASYRSA_REQ_EMAIL "Anonymous"
EOF
  rm -rf pki
  $BIN init-pki
  $BIN build-ca nopass << EOF
CA
EOF
  $BIN gen-req server nopass << EOF
server$RANDOM
EOF
  $BIN sign server server << EOF
yes
EOF
  $BIN gen-dh
  \cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem server/
fi

docker build --build-arg DEBUG=${DEBUG} -t $NAME:$PORT .

docker stop $NAME-$PORT || true
docker rm $NAME-$PORT || true
docker images  | grep '<none>' | awk '{print$3}'| while read ID; do echo "docker rmi $ID"; docker rmi $ID; done

docker run -d --name $NAME-$PORT --init --restart=always --cap-add NET_ADMIN --device=/dev/net/tun -e USERNAME=admin -e PASSWORD=$PASSWORD -p $PORT:1194/udp $NAME:$PORT

cat pki/ca.crt
#rm -rf pki vars server/ca.crt server/server.crt server/server.key server/dh.pem
cat client/client.ovpn

sleep 1 && docker logs $NAME-$PORT

if $ENTER_ENV; then
  docker exec -it $NAME-$PORT /bin/sh
fi


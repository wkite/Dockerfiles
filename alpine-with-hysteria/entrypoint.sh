#!/bin/sh

PORT=${PORT:-7000}
PASSWORD=${PASSWORD:-default-password}

cat << EOF > /hysteria.json
{
  "listen": ":${PORT}",
  "obfs": "${PASSWORD}",
  "cert": "/ca.crt",
  "key": "/ca.key"
}
EOF

hysteria -c /hysteria.json server


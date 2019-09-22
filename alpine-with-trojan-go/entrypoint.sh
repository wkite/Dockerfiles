#!/bin/sh

PASSWORD=${PASSWORD:-default-password}

SNI=${SNI:-bing.com}

cat << EOF > /server.yaml
run-type: server
local-addr: 0.0.0.0
local-port: 443
remote-addr: bing.com
remote-port: 80
password:
  - ${PASSWORD}
ssl:
  cert: /ca.crt
  key: /ca.key
  sni: bing.com
router:
  enabled: true
  block:
    - 'geoip:private'
  geoip: /geoip.dat
  geosite: /geosite.dat
EOF

/trojan-go -config /server.yaml

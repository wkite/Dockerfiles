# alpine-with-pptpd
## Build image or pull image
```bash
#Build image
docker build -t alpine-with-pptpd:latest alpine-with-pptpd
#or pull image from dockerhub
docker pull wkite/alpine-with-pptpd:latest
```

## Before start container
```bash
modprobe nf_nat_pptp
sysctl -w net.ipv4.ip_forward=1
```

## Start container
```bash
docker run -d --privileged -e "PPTP_USERNAME=yourusername" -e "PPTP_PASSWORD=yourpassword" -p 1723:1723/tcp alpine-with-pptpd:latest
```

## Install client on CentOS 7
```bash
yum install -y pptp pptp-setup
\cp /usr/share/doc/ppp-2.4.5/scripts/poff /usr/sbin/poff
chmod +x /usr/sbin/poff
\cp /usr/share/doc/ppp-2.4.5/scripts/pon /usr/sbin/pon
chmod +x /usr/sbin/pon
```

## Config client
```bash
PPTP_NAME=pptp #Connection name of pptp
SERVER_IP=XX.XX.XX.XX #Server ip of pptp server
PPTP_USERNAME=yourusername #default is username
PPTP_PASSWORD=yourpassword #default is password
pptpsetup --delete $PPTP_NAME
pptpsetup --create $PPTP_NAME --server $SERVER_IP --username $PPTP_USERNAME --password $PPTP_PASSWORD --encrypt
cat >> /etc/ppp/peers/$PPTP_NAME << EOF
refuse-pap
refuse-chap
refuse-eap
refuse-mschap
defaultroute
usepeerdns
EOF
```

## Start pptp client
```bash
pon pptp
sleep 5 # wait for interface ppp0 bringing up
route add -net 0.0.0.0 dev ppp0 #add default gateway
```

## Stop pptp client
```bash
poff pptp
```

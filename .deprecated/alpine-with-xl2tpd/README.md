# alpine-with-xl2tp

## Build image or pull image
```bash
#Build image
docker build -t alpine-with-xl2tpd:latest alpine-with-xl2tpd
#or pull image from dockerhub
docker pull wkite/alpine-with-xl2tpd:latest
```

## Before start container
```bash
modprobe nf_nat_pptp
sysctl -w net.ipv4.ip_forward=1
```

## Start container
```bash
docker run -d --privileged -e "L2TP_USERNAME=yourusername" -e "L2TP_PASSWORD=yourpassword" -p 1701:1701/udp alpine-with-xl2tpd:latest
```





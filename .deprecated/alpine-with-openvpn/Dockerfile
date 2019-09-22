FROM alpine:latest

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV USERNAME=admin \
    PASSWORD=defaultmima

RUN apk add --no-cache openvpn iptables

COPY server /etc/openvpn

EXPOSE 1194/udp

CMD cat /etc/openvpn/ca.crt && \
    echo "$USERNAME $PASSWORD" > /etc/openvpn/psw-file && \
    echo "USERNAME:PASSWORD=$USERNAME:$PASSWORD" && \
    iptables -t nat -A POSTROUTING -s 10.192.168.0/24 -o eth0 -j MASQUERADE && \
    openvpn --cd /etc/openvpn/ --config server.conf

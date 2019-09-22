FROM alpine:latest

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV KCP_VER=20200409
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN set -ex && \
    apk add --no-cache openvpn iptables wget && \
    wget -q --no-check-certificate $KCP_URL -O - | tar xz server_linux_amd64 && \
    mv server_linux_amd64 /usr/bin/

ENV USERNAME=admin \
    PASSWORD=defaultmima \
    KCP_MTU=1450 \
    KCP_MODE=fast \
    KCP_ENCRYPT=none \
    KCP_PASSWORD=none-encrypt \
    KCP_SNDWND=2048 \
    KCP_RCVWND=512 \
    KCP_DATASHARD=10 \
    KCP_PARITYSHARD=6 \
    KCP_NOCOMP=''
    #KCP_NOCOMP=--nocomp

COPY server /etc/openvpn

EXPOSE 29900/udp

CMD cat /etc/openvpn/ca.crt && \
    echo "$USERNAME $PASSWORD" > /etc/openvpn/psw-file && \
    echo "USERNAME:PASSWORD=$USERNAME:$PASSWORD" && \
    iptables -t nat -A POSTROUTING -s 10.192.168.0/24 -o eth0 -j MASQUERADE && \
    openvpn --daemon --cd /etc/openvpn/ --config server.conf && \
    server_linux_amd64 \
        -l ":29900" \
        -t "127.0.0.1:1194" \
        --mtu $KCP_MTU \
        --mode $KCP_MODE \
        --crypt $KCP_ENCRYPT \
        --key $KCP_PASSWORD \
        --sndwnd $KCP_SNDWND \
        --rcvwnd $KCP_RCVWND \
        --datashard $KCP_DATASHARD \
        --parityshard $KCP_PARITYSHARD \
        $KCP_NOCOMP

FROM alpine:latest

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV SS_VER=1.11.2 \
    KCP_VER=20210624
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-rust/releases/download/v$SS_VER/shadowsocks-v$SS_VER.x86_64-unknown-linux-musl.tar.xz
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN set -ex && \
    apk add --no-cache --virtual wget tar xz tini && \
    wget -q --no-check-certificate $KCP_URL -O - | tar zx server_linux_amd64 && \
    mv server_linux_amd64 /usr/bin/ && \
    wget -q --no-check-certificate $SS_URL -O - | tar Jx ssserver && \
    mv ssserver /usr/bin/

ENV PASSWORD=defaultmima \
    SS_METHOD=chacha20-ietf-poly1305 \
    SS_DNS=8.8.8.8 \
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

EXPOSE 8388/tcp 29900/udp

ENTRYPOINT ["/sbin/tini", "--"]

CMD /usr/bin/ssserver \
        -s "127.0.0.1:8388" \
        -k $PASSWORD \
        -m $SS_METHOD \
        --dns $SS_DNS \
        -d \
    && server_linux_amd64 \
        -l ":29900" \
        -t "127.0.0.1:8388" \
        --mtu $KCP_MTU \
        --mode $KCP_MODE \
        --crypt $KCP_ENCRYPT \
        --key $KCP_PASSWORD \
        --sndwnd $KCP_SNDWND \
        --rcvwnd $KCP_RCVWND \
        --datashard $KCP_DATASHARD \
        --parityshard $KCP_PARITYSHARD \
        $KCP_NOCOMP

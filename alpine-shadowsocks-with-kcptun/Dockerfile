FROM alpine:3.13.5

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV SS_VER=3.3.5 \
    KCP_VER=20210624
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz

RUN set -ex \
    && mkdir -p /mktmp \
    && cd /mktmp \
    && apk add --no-cache --virtual .build-deps \
                                    autoconf \
                                    build-base \
                                    wget \
                                    libev-dev \
                                    libtool \
                                    linux-headers \
                                    udns-dev \
                                    libsodium-dev \
                                    mbedtls-dev \
                                    pcre-dev \
                                    tar \
                                    tzdata \
                                    udns-dev \
                                    c-ares-dev \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && wget -q --no-check-certificate $KCP_URL -O - | tar xz server_linux_amd64 \
    && mv server_linux_amd64 /usr/bin/ \
    && wget -q --no-check-certificate $SS_URL -O - | tar xz --strip 1 \
    && ./configure --prefix=/usr --disable-documentation \
    && make -j4 \
    && cp src/ss-server /usr/bin/ \
    && cd .. \
    && runDeps="$(scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u)" \
    && apk add --no-cache --virtual .run-deps $runDeps tini \
    && apk del .build-deps \
    && rm -rf /mktmp

ENV PASSWORD=defaultmima \
    SS_METHOD=chacha20-ietf-poly1305 \
    SS_TIMEOUT=300 \
    SS_USER=nobody \
    SS_DNS1=8.8.8.8 \
    SS_DNS2=8.8.4.4 \
    SS_UDP=-u \
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

CMD ss-server \
        -p 8388 \
        -k $PASSWORD \
        -m $SS_METHOD \
        -t $SS_TIMEOUT \
        -a $SS_USER \
        -d $SS_DNS1 \
        -d $SS_DNS2 \
        -f /tmp/ss.pid \
        $SS_UDP \
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

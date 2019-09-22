FROM alpine:latest

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV SS_VER=3.3.4 \
    KCP_VER=20200409

COPY wget.sh clean.sh /bin/

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
                                    apache2-utils \
                                    udns-dev \
                                    c-ares-dev \
    && ln /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && ln /usr/bin/htpasswd /bin/htpasswd \
    && wget -q --no-check-certificate https://github.com/xtaci/kcptun/releases/download/v$KCP_VER/kcptun-linux-amd64-$KCP_VER.tar.gz -O - | tar xz server_linux_amd64 \
    && mv server_linux_amd64 /usr/bin/ \
    && wget -q --no-check-certificate https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz -O - | tar xz --strip 1 \
    && ./configure --prefix=/usr --disable-documentation \
    && make -j4 \
    && cp src/ss-server /usr/bin/ \
    && cd .. \
    && runDeps="$(scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u)" \
    && apk add --no-cache --virtual .run-deps $runDeps wget apache2 php php-apache2 \
    && apk del .build-deps \
    && rm -rf /mktmp \
    && mkdir -p /var/www/html/.sh \
    && echo "<?php phpinfo(); ?>" > /var/www/html/.sh/info.php \
    && ln /bin/wget.sh /bin/wg \
    && ln /bin/clean.sh /bin/cl \
    && find /sbin/* /usr/sbin/* | grep -v http | xargs rm -f

COPY httpd.conf /etc/apache2/
COPY index.php /var/www/html/.sh/
COPY htaccess /var/www/html/.htaccess

RUN chown -R apache.apache /var/www/html

ENV USERNAME=admin \
    PASSWORD=defaultmima \
    SS_PASSWORD=defaultmima \
    SS_METHOD=aes-256-cfb \
    SS_TIMEOUT=300 \
    SS_DNS1=8.8.8.8 \
    SS_DNS2=8.8.4.4 \
    SS_FASTOPEN=--fast-open \
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

EXPOSE 80/tcp 8388/tcp 29900/udp

CMD htpasswd -b -c /var/www/html/.htpasswd $USERNAME $PASSWORD && \
    echo "USERNAME:PASSWORD=$USERNAME:$PASSWORD" && \
    /usr/sbin/httpd && \
    /usr/bin/ss-server \
        -p 8388 \
        -k $SS_PASSWORD \
        -m $SS_METHOD \
        -t $SS_TIMEOUT \
        -a nobody \
        -d $SS_DNS1 \
        -d $SS_DNS2 \
        -f /tmp/ss.pid \
        $SS_FASTOPEN \
        $SS_UDP && \
    /usr/bin/server_linux_amd64 \
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

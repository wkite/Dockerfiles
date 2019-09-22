FROM alpine:latest

ENV VERSION=20210116.0 \
    PORT=51820 \
    SPEEDER_PORT=51821 \
    NUM=10 \
    GAME_MODE=false \
    FEC=10:10

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ARG URL=https://github.com/wangyu-/UDPspeeder/releases/download/$VERSION/speederv2_binaries.tar.gz

RUN apk add --no-cache tini wget iptables wireguard-tools libqrencode && \
    wget -q --no-check-certificate $URL -O- | tar xz speederv2_amd64

COPY *.key *.pub entrypoint.sh /etc/wireguard/

EXPOSE 51820-51821/udp

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/etc/wireguard/entrypoint.sh"]

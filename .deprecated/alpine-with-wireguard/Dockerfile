FROM alpine:latest

ENV PORT=51820 \
    NUM=3

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

RUN apk add --no-cache tini wget iptables wireguard-tools libqrencode

COPY *.key *.pub entrypoint.sh /etc/wireguard/

EXPOSE 51820/udp

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/etc/wireguard/entrypoint.sh"]

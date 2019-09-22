FROM alpine:latest

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV VERSION=v0.10.6

RUN set -ex && \
    apk add --no-cache tini wget unzip tzdata ca-certificates && \
    wget -q --no-check-certificate https://github.com/p4gefau1t/trojan-go/releases/download/${VERSION}/trojan-go-linux-amd64.zip && \
    unzip -q trojan-go-linux-amd64.zip && \
    rm -f trojan-go-linux-amd64.zip && \
    wget -q --no-check-certificate https://github.com/v2fly/domain-list-community/raw/release/dlc.dat -O geosite.dat && \
    wget -q --no-check-certificate https://github.com/v2fly/geoip/raw/release/geoip.dat -O geoip.dat

COPY entrypoint.sh ca.crt ca.key Dockerfile /

EXPOSE 443/tcp

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/entrypoint.sh"]

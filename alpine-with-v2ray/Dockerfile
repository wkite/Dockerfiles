FROM alpine:latest

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV V2RAY_VER=4.20.0 \
    UUID=11111111-2222-3333-4444-555555555555
ARG URL=https://github.com/v2ray/v2ray-core/releases/download/v$V2RAY_VER/v2ray-linux-64.zip

RUN apk add --no-cache wget && \
    cd /dev/shm && \
    wget -q --no-check-certificate $URL && \
    unzip v2ray-linux-64.zip && \
    mv v2ray v2ctl geo* /opt && \
    mv vpoint_vmess_freedom.json /opt/config.json && \
    rm -rf /dev/shm/*

EXPOSE 10086/tcp

CMD sed -ri "s/\w{4}(\w{4}-){4}\w{12}/$UUID/" /opt/config.json && \
    cat /opt/config.json && \
    /opt/v2ray

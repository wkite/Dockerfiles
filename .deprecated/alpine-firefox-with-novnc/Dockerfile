FROM alpine:latest

RUN echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk update --no-cache && \
    apk add ttf-dejavu x11vnc xvfb openbox xfce4-terminal supervisor bash sudo procps python3 py3-numpy firefox ca-certificates wget wqy-zenhei@edge && \
    mkdir -p /opt/noVNC/utils/websockify && \
    wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C /opt/noVNC && \
    wget -qO- https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar xzf - --strip 1 -C /opt/noVNC/utils/websockify && \
    cp /opt/noVNC/vnc_lite.html /opt/noVNC/index.html && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    echo "root:alpine65536" | /usr/sbin/chpasswd && \
    x11vnc -storepasswd alpine65536 /root/.vncpasswd

ADD etc /etc

EXPOSE 5900/tcp 6080/tcp

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

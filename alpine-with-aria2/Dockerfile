FROM alpine:latest

ARG DEBUG=false
RUN if $DEBUG; then sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; fi

ENV USERNAME=admin \
    PASSWORD=default-password

COPY scripts.sh /bin/
COPY html /var/www/html

RUN /bin/scripts.sh && \
    rm -f /bin/scripts.sh && \
    apk add --no-cache tini wget axel apache2 php php-apache2 php-sqlite3 php-session aria2 apache2-utils tzdata && \
    ln -f /usr/bin/htpasswd /bin/htpasswd && \
    ln -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    touch /tmp/aria2.session.main && \
    chown apache.apache /tmp/aria2.session.main && \
    apk del apache2-utils tzdata && \
    find /sbin/* /usr/sbin/* | grep -v http | grep -v tini | xargs rm -f

COPY entrypoint.sh /
COPY aria2.conf /etc/aria2.conf
COPY httpd.conf /etc/apache2/

EXPOSE 80/tcp 6800/tcp

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/entrypoint.sh"]

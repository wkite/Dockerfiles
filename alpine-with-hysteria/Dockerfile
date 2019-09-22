FROM tobyxdd/hysteria

RUN set -ex && \
    apk upgrade && \
    apk add tini && \
    rm -rf /var/cache/apk/*

COPY ca.* entrypoint.sh Dockerfile /

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/entrypoint.sh"]

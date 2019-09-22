FROM centos:7.6.1810

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="CentOS Base Image" \
    org.label-schema.vendor="CentOS" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20190214"

RUN set -ex \
    && mkdir -p /root/.pip \
    && echo '[global]' > /root/.pip/pip.conf \
    && echo 'index-url = https://mirrors.huaweicloud.com/repository/pypi/simple' >> /root/.pip/pip.conf \
    && echo 'format = columns' >> /root/.pip/pip.conf

CMD ["/bin/bash"]

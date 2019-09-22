FROM centos:7.6.1810

ENV USERNAME=root PASSWORD=''

RUN set -ex \
    && yum-config-manager --disable updates \
    && yum -y install systemd initscripts sudo chrony openssh-server openssh-clients wget telnet \
    && yum -y install https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.14.4/RPMS/x86_64/oracle-j2sdk1.7-1.7.0+update67-1.x86_64.rpm \
    && yumdownloader mysql-connector-java \
    && rpm2cpio mysql-connector-java*rpm | cpio -idv ./usr/share/java/mysql-connector-java.jar \
    && rm -f mysql-connector-java*rpm \
    && yum clean all \
    && systemctl disable network getty@tty1 \
    && systemctl mask network getty@tty1 systemd-udevd systemd-udevd-control.socket systemd-udevd-kernel.socket systemd-udev-trigger systemd-udev-settle \
    && sed -ri 's/^.?UseDNS.*/UseDNS no/' /etc/ssh/sshd_config \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo '*                -       core           3145728' >> /etc/security/limits.conf \
    && echo '*                -       nofile          65535' >> /etc/security/limits.conf

EXPOSE 22/tcp

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

FROM centos:7.5.1804

ENV SSH_USER=root \
    SSH_PASSWORD=''

RUN set -ex \
    && yum-config-manager --disable updates \
    && yum install -y systemd initscripts sudo chrony openssh-server openssh-clients wget telnet \
    && yum clean all \
    && sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config \
    && ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
    && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''

EXPOSE 22/tcp

CMD test "$SSH_USER" != 'root' \
    && useradd -G wheel "$SSH_USER" \
    || echo 'User name is root' \
    && test -n "$SSH_PASSWORD" \
    && echo 'Use the provided password' \
    || SSH_PASSWORD=$(cat /dev/urandom | head -c32 | md5sum | cut -b -8) \
    && echo "$SSH_USER:$SSH_PASSWORD" \
    && echo "$SSH_USER:$SSH_PASSWORD" | chpasswd \
    && exec /usr/sbin/sshd -D

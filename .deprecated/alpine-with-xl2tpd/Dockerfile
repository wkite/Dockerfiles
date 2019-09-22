FROM alpine:latest

RUN apk add --no-cache xl2tpd iptables ppp
RUN sed -i 's/^ms-dns/#ms-dns/' /etc/ppp/options.xl2tpd && \
    echo 'ms-dns  8.8.8.8' >> /etc/ppp/options.xl2tpd && \
    echo 'ms-dns  223.5.5.5' >> /etc/ppp/options.xl2tpd && \
    sed -i 's/168.1/168.128/g' /etc/xl2tpd/xl2tpd.conf

ENV L2TP_USERNAME=username \
L2TP_PASSWORD=password

EXPOSE 1701/udp

CMD set -ex && \
    echo "$L2TP_USERNAME * $L2TP_PASSWORD *" > /etc/ppp/chap-secrets && \
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE && \
    xl2tpd -D

#!/bin/bash
set -ex

command -v httpd && : || yum -y install httpd && \
systemctl start httpd && \
rm -rf ~/.acme.sh/$(hostname -f) /mnt/cert && \
curl -sSL https://get.acme.sh | sh -s -- email=admin@$(hostname -d) --issue -d $(hostname -f) --webroot /var/www/html/ && \
systemctl stop httpd && \
mv ~/.acme.sh/$(hostname -f) /mnt/cert

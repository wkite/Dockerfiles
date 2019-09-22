#!/bin/bash
set -ex

command -v openssl && : || yum -y install openssl && \
rm -f ca.key ca.crt && \
openssl ecparam -genkey -name prime256v1 -out ca.key && \
openssl req -new -x509 -days 36500 -key ca.key -out ca.crt  -subj "/CN=bing.com"

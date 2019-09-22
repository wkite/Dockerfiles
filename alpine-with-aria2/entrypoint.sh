#!/bin/sh
if [ ! -f /var/www/html/.htaccess ]; then
  cat << EOF > /var/www/html/.htaccess
AuthName "sys"
AuthType Basic
AuthUserFile /var/www/html/.htpasswd
require user $USERNAME
EOF
  htpasswd -b -c /var/www/html/.htpasswd $USERNAME $PASSWORD
  echo "USERNAME:PASSWORD=$USERNAME:$PASSWORD"
fi

if [ ! -d /var/www/html/media/Downloads ]; then
  mkdir -p /var/www/html/media/Downloads
fi
chown -R apache.apache /var/www/html/media

if [ ! -f /var/www/html/rpc ]; then
  echo $(grep -o '[A-Z0-9]' /dev/urandom | head -32) | sed 's/ //g' | tee /var/www/html/rpc
  sed -ri "s/^rpc-secret.*/rpc-secret=$(cat /var/www/html/rpc)/" /etc/aria2.conf
fi

/usr/sbin/httpd
su - apache -s '/bin/ash' -c '/usr/bin/aria2c --conf-path=/etc/aria2.conf'

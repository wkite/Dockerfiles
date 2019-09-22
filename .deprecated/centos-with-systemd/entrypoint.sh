#!/bin/bash
#setup password for first boot
#set -ex
if [ ! -f /.firstboot ]; then
  if [ -z "$USERNAME" ]; then
    echo 'Found none user, use root.'
    USERNAME=root
  elif [ ${USERNAME} == 'root' ]; then
    :
  else
    useradd -m -G wheel ${USERNAME}
    :
  fi
  echo "User Name:${USERNAME}"
  if [ -z "$PASSWORD" ]; then
    echo 'Found none password, generate password.'
    PASSWORD=$(head -c 64 /dev/urandom | md5sum | cut -b -12)
  fi
  echo "$USERNAME:$PASSWORD"
  echo "$USERNAME:$PASSWORD" | chpasswd
  touch /.firstboot
fi
exec /sbin/init

#!/bin/bash

mkdir -p /etc/opendkim/keys
mkdir -p /etc/opendkim/keys/example.com
opendkim-genkey \
    -d exampel.com \
    -s mail \
    -D /etc/opendkim/keys/example.com/ \ 


chown -R opendkim:opendkim /etc/opendkim
chmod -R 0700 /etc/opendkim/keys


echo "root@example.com    root" >  /etc/postfix/sender_login
chmod -R 0600 /etc/postfix/sender_login
postmap /etc/postfix/sender_login

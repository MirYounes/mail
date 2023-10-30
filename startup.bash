#!/bin/bash


if [[ ! -f "/etc/opendkim/keys/example.com/mail.private" ]]; then
    mkdir -p /etc/opendkim/keys
    mkdir -p /etc/opendkim/keys/example.com
    opendkim-genkey \
        -d exampel.com \
        -s mail \
        -D /etc/opendkim/keys/example.com/ \ 
fi

chown -R opendkim:opendkim /etc/opendkim
chmod -R 0700 /etc/opendkim/keys
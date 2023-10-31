#!/bin/bash

echo -e "   DKIM_DOMAIN = ${DOMAIN}"

postconf mydomain="${DOMAIN}"
postconf myhostname="${HOST}"

mkdir /etc/opendkim
echo "127.0.0.1" >> /etc/opendkim/TrustedHosts
echo "localhost" >> /etc/opendkim/TrustedHosts
echo "*.${DOMAIN}" >> /etc/opendkim/TrustedHosts
echo "*@${DOMAIN} mail._domainkey.${DOMAIN}" >> /etc/opendkim/SigningTable
echo "mail._domainkey.${DOMAIN} ${DOMAIN}:mail:/etc/opendkim/keys/${DOMAIN}/mail.private" >> /etc/opendkim/KeyTable

mkdir -p /etc/opendkim/keys
mkdir -p /etc/opendkim/keys/${DOMAIN}
opendkim-genkey \
    -d ${DOMAIN} \
    -s mail \
    -D /etc/opendkim/keys/${DOMAIN}/ 

chown -R opendkim:opendkim /etc/opendkim
chmod -R 0700 /etc/opendkim/keys


echo "root@${DOMAIN}    root" >  /etc/postfix/sender_login
chmod -R 0600 /etc/postfix/sender_login
postmap /etc/postfix/sender_login

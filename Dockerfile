FROM ubuntu:latest

ARG DOMAIN
ARG HOST 

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y postfix

RUN  apt-get install -y opendkim \
    opendkim-tools\
    dovecot-imapd \
    dovecot-pop3d \
    syslog-ng

COPY postfix/main.cf /etc/postfix/main.cf
RUN mkdir /etc/postfix/cert
COPY certs/private-key.pem /etc/postfix/certs/private-key.pem
COPY certs/cert.pem /etc/postfix/certs/cert.pem

COPY dovecot/master.conf /etc/dovecot/conf.d/10-master.conf
COPY dovecot/auth.conf /etc/dovecot/conf.d/10-auth.conf

COPY opendkim/opendkim.conf /etc/opendkim.conf
COPY opendkim/default /etc/default/opendkim

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh && ./startup.sh


CMD ["sh", "-c", "service syslog-ng start ; /usr/sbin/opendkim -x /etc/opendkim.conf -u opendkim ; service postfix start ; service dovecot start ; tail -F /var/log/mail.log"]
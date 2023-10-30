FROM ubuntu:latest

RUN apt-get update

# Install Postfix.
RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
RUN echo "postfix postfix/mailname string mail.example.com" >> preseed.txt
# Use Mailbox format.
RUN debconf-set-selections preseed.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

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
RUN mkdir /etc/opendkim
COPY opendkim/TrustedHosts /etc/opendkim/TrustedHosts
COPY opendkim/KeyTable /etc/opendkim/KeyTable
COPY opendkim/SigningTable /etc/opendkim/SigningTable
RUN mkdir mkdir /etc/opendkim/keys
RUN mkdir /etc/opendkim/keys/example.com

EXPOSE 25

CMD ["sh", "-c", "opendkim-genkey -s mail -d example.com ;  mv mail.* /etc/opendkim/keys/example.com/; chown opendkim:opendkim /etc/opendkim/keys/example.com/mail.private ; service syslog-ng start ; service start opendkim ; service postfix start ; service dovecot start ; tail -F /var/log/mail.log"]
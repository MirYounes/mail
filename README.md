# setup
- set DOMAIN and HOST variables in .env :
```
DOMAIN = example.com
HOST = mail.example.com
```
- copy generated certs in certs/cert.pem and certs/private-key.pem :
```
$ cat {private-key-file-path} > certs/private-key.pem
$ cat {cert-file-path} > certs/cert.pem
``` 
- up
```
$ sudo docker compose up -d
```

# DKIM DNS record
```
$ sudo docker exec -it mail bash
$ cat /etc/opendkim/keys/{domain}/mail.txt
```

# create user
```
$ sudo docker exec -it mail bash
$ adduser {username}
$ echo "{username}@{domain}    {username}" >> /etc/postfix/sender_login
$ postmap /etc/postfix/sender_login
```

# logs
```
sudo docker compose logs -f
```

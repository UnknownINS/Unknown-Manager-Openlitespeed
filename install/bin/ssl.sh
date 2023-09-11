#!/bin/bash

verifyCertbot(){
  if [ ! -f '/snap/bin/certbot' ]; then
    echo "SSL/HTTP Not Install.Please try again later"
     exit
  fi

}
installSslForDomain() {

  verifyCertbot

  textYellow "----------------> INSTALL SSL/HTTPS FOR DOMAIN"

  echo ''

  read -p "----------------> Enter Domain : " domain

  certbot certonly --non-interactive --agree-tos -m root@localhost --webroot -w $UNKNOWN_DIR/$domain/html -d $domain

  echo ''

  textMagenta "----------------> INSTALL AUTO RENEW SSL/HTTPS SUCCESS"

  echo ''

}

renewSSLNow() {

  verifyCertbot

  textYellow "----------------> RENEW SSL/HTTPS"
  echo ''
  certbot renew
  textMagenta "----------------> RENEW SSL/HTTPS SUCCESS"
  echo ''
}

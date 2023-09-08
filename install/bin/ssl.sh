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

  certbot certonly --non-interactive --agree-tos -m admin@gmail.com --webroot -w $UNKNOWN_DIR/$domain/html -d $domain

  echo ''

  textMagenta "_________________ INSTALL AUTO RENEW SSL/HTTPS SUCCESS ________________"

  echo ''

}

renewSSLNow() {

  verifyCertbot

  textYellow "----------------> RENEW SSL/HTTPS"
  echo ''
  certbot renew
  textMagenta "_________________ RENEW SSL/HTTPS SUCCESS ________________"
  echo ''
}

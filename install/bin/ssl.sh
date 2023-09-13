#!/bin/bash

verifyCertbot() {
  if [ ! -f '/snap/bin/certbot' ]; then
    textRed "SSL/HTTP Not Install.Please try again later"
    exit
  fi

}
installSslForDomain() {

  verifyCertbot

  textYellow "----------------> INSTALL SSL/HTTPS FOR DOMAIN"

  echo ''

  read -p "----------------> Enter Domain : " domain

  if [ -z "$domain" ]; then
    textRed "Please try again later"
    echo ''
    exit
  fi

  certbot certonly --non-interactive --agree-tos -m admin@gmail.com --webroot -w $UNKNOWN_DIR/$domain/html -d $domain

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

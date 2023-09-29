#!/bin/bash

verifyCertbot() {
  if [ ! -f '/snap/bin/certbot' ]; then
    textRed "----------------> PLEASE CHECK HTTPS/SSL AGAIN"
    exit
  fi

}
installSslForDomain() {

  verifyCertbot

  textYellow "----------------> INSTALL SSL/HTTPS FOR DOMAIN"

  read -p "----------------> Enter Domain : " domain

  if [ -z "$domain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi

  verifyDir $domain

  installSslCLI $domain

  restartWebserver

  textMagenta "----------------> INSTALL AUTO RENEW SSL/HTTPS SUCCESS"

}

renewSSLNow() {
  verifyCertbot
  textYellow "----------------> RENEW SSL/HTTPS"
  certbot renew
  textMagenta "----------------> RENEW SSL/HTTPS SUCCESS"
}

installSslCLI(){
  certbot certonly --non-interactive --agree-tos -m admin@gmail.com --webroot -w $UNKNOWN_DIR/$1/html -d $1
}

#!/bin/bash

autoRenewSSL(){

  mycron=$(crontab -l)

  if [[ mycron =~ "certbot renew" ]]; then
      textRed "Command already exists"
    else
    printf "0 1 * * * certbot renew &> /dev/null " >> mycron
  fi

  sudo crontab mycron

  rm mycron
}

installSslForDomain(){

    textYellow "----------------> INSTALL SSL/HTTPS FOR DOMAIN"

    echo ''

    read -p "----------------> Enter Domain : " domain

    certbot certonly --non-interactive --agree-tos -m admin@gmail.com --webroot -w $UNKNOWN_DIR/$domain/html -d $domain

    echo ''

    textMagenta "_________________ INSTALL AUTO RENEW SSL/HTTPS SUCCESS ________________"

    echo ''

}

renewSSLNow(){

    textYellow "----------------> RENEW SSL/HTTPS"
    echo ''
    certbot renew
    textMagenta "_________________ RENEW SSL/HTTPS SUCCESS ________________"
    echo ''
}
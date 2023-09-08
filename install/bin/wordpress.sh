#!/bin/bash

wpCreateWebsite() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyCertbot

  echo ''

  read -p "----------------> Enter Domain : " inputDomain

  validate="^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$"

  if [[ -z "$inputDomain" ]]; then

    textRed "You must enter a domain"

    echo ''

    exit
  fi

  if [ -d $UNKNOWN_DIR/$inputDomain ]; then
    textRed "Domain exist."
    echo ''
    exit
  fi

  if [[ "$inputDomain" =~ $validate ]]; then
    echo ''
  else
    textRed "Not valid $inputDomain name."
    echo ''
    exit
  fi

  nameDatabase=${inputDomain/"."/"_"}

  textYellow "----------------> CREATE DATABASE FOR WEBSITE"

  echo ""

  createDatabase $nameDatabase &>/dev/null

  mkdir -p $UNKNOWN_DIR/$inputDomain/html

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  textYellow "----------------> DOWNLOAD WORDPRESS CORE"

  echo ""

  wp core download --allow-root &>/dev/null

  textYellow "----------------> WORDPRESS CORE CONFIG"

  echo ""

  wp core config --dbhost=localhost --dbname=$nameDatabase --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --allow-root &>/dev/null

  textYellow "----------------> WORDPRESS CORE INSTALL"

  echo ""

  wp core install --url=$inputDomain --title="News Website" --admin_name=admin --admin_password=123456789 --admin_email=admin@gmail.com --allow-root &>/dev/null

  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html

  textYellow "----------------> INSTALL VIRTUALHOST"

  echo ""

  createVirtualHost $inputDomain

  updateHTTPConfig

  textYellow "----------------> INSTALL SSL/HTTPS"

  certbot certonly --non-interactive --agree-tos -m admin@gmail.com --webroot -w $UNKNOWN_DIR/$inputDomain/html -d $inputDomain &>/dev/null

  echo ""

  cd $UNKNOWN_DIR || exit

  textMagenta "----------------> CREATE WEBSITE SUCCESS"

  echo ""

  restartWebserver
}

wpUpdateWebsite() {

  textYellow "----------------> UPDATE WEBSITE"

  echo ""

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  for i in $ALLDOMAIN; do

    if [[ $i != "localhost" ]]; then

      textBlue "----------------> $i"

      chown -R nobody:nogroup $UNKNOWN_DIR/$i/html

      echo ""

      cd $UNKNOWN_DIR/$i/html || exit

      wp core update --allow-root &>/dev/null

      wp plugin update --all --allow-root &>/dev/null

    fi

  done

  textMagenta "----------------> UPDATE WEBSITE SUCCESS"

  echo ''

}

wpDeleteWebsite(){

    verifyExitOpenLiteSpeed

    verifyMariadb
    echo ''

    read -p "----------------> Input Domain : " inputDomain

    echo ''

    textYellow "----------------> DELETE WEBSITE"

    echo ''

    rm -rf $UNKNOWN_DIR/$inputDomain &> /dev/null

    rm -rf $LSWS_VHOSTS/$inputDomain &> /dev/null

    nameDatabase=${inputDomain/"."/"_"}

    deleteDatabase $nameDatabase

    textYellow "----------------> UPDATE HTTP/HTTPS CONFIG"

    updateHTTPConfig

    echo ''

    restartWebserver
}
#!/bin/bash

wpCreateWebsite() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyCertbot

  verifyConstainDatabase

  echo ''

  read -p "----------------> Enter Domain : " inputDomain

  validate="^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$"

  if [[ -z "$inputDomain" ]]; then

    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"

    echo ''

    exit
  fi

  verifyExitDir $UNKNOWN_DIR/$inputDomain

  if [[ "$inputDomain" =~ $validate ]]; then
    echo ''
  else
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    echo ''
    exit
  fi

  textYellow "----------------> CREATE DATABASE FOR WEBSITE"

  echo ""

  nameDatabase=$(sed "s/\./_/g" <<<"$inputDomain")

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

  rm $UNKNOWN_DIR/$inputDomain/html/index.html &> /dev/null

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

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

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

wpDeleteWebsite() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  echo ''

  read -p "----------------> Input Domain : " inputDomain

  if [ -z "$inputDomain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    echo ''
    exit
  fi

  verifyDir $UNKNOWN_DIR/$inputDomain/html

  echo ''

  textYellow "----------------> DELETE WEBSITE"

  echo ''

  rm -rf $UNKNOWN_DIR/$inputDomain &>/dev/null

  rm -rf $LSWS_VHOSTS/$inputDomain &>/dev/null

  nameDatabase=$(sed "s/\./_/g" <<<"$inputDomain")

  deleteDatabase $nameDatabase &>/dev/null

  textYellow "----------------> UPDATE HTTP/HTTPS CONFIG"

  updateHTTPConfig

  echo ''

  restartWebserver
}

wpGetListUser() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  echo ''

  read -p "----------------> Input Domain : " inputDomain

  echo ''

  if [ -z "$inputDomain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    echo ''
    exit
  fi

  verifyDir $UNKNOWN_DIR/$inputDomain/html

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  wp user list --allow-root

  echo ''

}

wpResetPassword() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  echo ''

  read -p "----------------> Input Domain : " inputDomain

  echo ''

  read -p "----------------> Input User Login : " userLogin

  echo ''

  read -p "----------------> Input PassWord : " passWord

  echo ''

  if [[ -z "$inputDomain" ]] || [[ -z "$userLogin" ]] || [[ -z "$passWord" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    echo ''
    exit
  fi

  verifyDir $UNKNOWN_DIR/$inputDomain/html

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  wp user update $userLogin --user_pass=$passWord --allow-root &>/dev/null

  textMagenta "----------------> UPDATE PASSWORD SUCCESS"

  echo ''

}

wpRenameDomain(){

    echo ''

    verifyMariadb

    verifyConstainDatabase

  textYellow "----------------> RENAME DOMAIN ( WORDPRESS )"

  echo ''

  read -p "----------------> New Domain Name : " inputDomain

  echo ''

  read -p "----------------> Old Domain Name : " oldDomain

  echo ''

    if [[ -z "$oldDomain" ]] || [[ -z "$inputDomain" ]]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
          echo ''
      exit
    fi

    verifyDir $UNKNOWN_DIR/oldDomain

    verifyExitDir $UNKNOWN_DIR/$inputDomain

}
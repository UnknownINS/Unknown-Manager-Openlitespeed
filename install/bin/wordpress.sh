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

  rm $UNKNOWN_DIR/$inputDomain/html/index.html &>/dev/null

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

wpRenameDomain() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  echo ''

  read -p "----------------> New Domain : " newDomain

  echo ''

  read -p "----------------> Old Domain : " oldDomain

  echo ''

  if [[ -z "$newDomain" ]] || [[ -z "$oldDomain" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    echo ''
    exit
  fi

  verifyDir $oldDomain

  verifyExitDir $newDomain

  textYellow "----------------> RENAME DATABASE"

  echo ''

  databaseNewDomain=$(sed "s/\./_/g" <<<"$newDomain")

  databaseOldDomain=$(sed "s/\./_/g" <<<"$oldDomain")

  renameDataBase $databaseOldDomain $databaseNewDomain

  textYellow "----------------> RENAME DOMAIN"
  echo ''

  mv $oldDomain $newDomain

  cd $UNKNOWN_DIR/$newDomain/html || exit

  wp config set DB_HOST "localhost" --allow-root &>/dev/null

  wp config set DB_NAME "$databaseNewDomain" --allow-root &>/dev/null

  wp config set DB_USER "$MYSQL_USER" --allow-root &>/dev/null

  wp config set DB_PASSWORD "$MYSQL_PASSWORD" --allow-root &>/dev/null

  wp search-replace $oldDomain $newDomain --all-tables --allow-root &>/dev/null

  rm -rf $LSWS_VHOSTS/$oldDomain &>/dev/null

  createVirtualHost $newDomain

  updateHTTPConfig

  chown -R nobody:nogroup $UNKNOWN_DIR/$newDomain/html &>/dev/null

  textYellow "----------------> INSTALL SSL/HTTPS"

  certbot certonly --non-interactive --agree-tos -m admin@gmail.com --webroot -w $UNKNOWN_DIR/$newDomain/html -d $newDomain &>/dev/null

  echo ''

  restartWebserver
}

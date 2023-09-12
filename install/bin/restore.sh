#!/bin/bash

restoreRemote() {

  echo ''

  verifyMariadb

  verifyConstainDatabase

  textYellow "----------------> RESTORE REMOTE"

  echo ''

  read -p "----------------> New Domain Name : " inputDomain

  echo ''

  read -p "----------------> Old Domain Name : " oldDomain

  echo ''

  read -p "----------------> URL Code Backup (.zip) : " urlCodeBackup

  echo ''

  read -p "----------------> URL Database Backup (.sql) : " urlDatabase

  verifyExitDir $UNKNOWN_DIR/$inputDomain

  echo ''

  cd /home || exit

  textYellow "----------------> DOWNLOAD CODE BACKUP"

  echo ''

  baseNameCode=$(basename $urlCodeBackup)

  baseNameSQL=$(basename $urlDatabase)

  wget $urlCodeBackup

  textYellow "----------------> DOWNLOAD SQL BACKUP"

  echo ''

  wget $urlDatabase

  textYellow "----------------> INSTALL BACKUP"

  echo ''

  nameDatabase=$(sed "s/\./_/g" <<<"$inputDomain")

  if [ -z $nameDatabase ]; then
    textRed "Domain please check again"
    echo ''
  fi

  if [ -z $oldDomain ]; then
    textRed "Domain please check again"
    echo ''
  fi

  createDatabase $nameDatabase &>/dev/null

  mkdir -p $UNKNOWN_DIR/$inputDomain/html

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  mv /home/$baseNameCode $UNKNOWN_DIR/$inputDomain/html

  mv /home/$baseNameSQL $UNKNOWN_DIR/$inputDomain/html

  unzip $baseNameCode &>/dev/null

  rm $baseNameCode &>/dev/null

  getFileName=${baseNameCode%.*}

  cp -r $getFileName/* ./ &>/dev/null

  rm -rf $getFileName &>/dev/null

  importDatabase $nameDatabase $UNKNOWN_DIR/$inputDomain/html/$baseNameSQL

  rm $UNKNOWN_DIR/$inputDomain/html/$baseNameSQL &>/dev/null

  textYellow "----------------> UPDATE CONFIG WEBSITE"
  echo ''

  wp config set DB_HOST "localhost" --allow-root &>/dev/null
  wp config set DB_NAME "$nameDatabase" --allow-root &>/dev/null
  wp config set DB_USER "$MYSQL_USER" --allow-root &>/dev/null
  wp config set DB_PASSWORD "$MYSQL_PASSWORD" --allow-root &>/dev/null
  wp search-replace $oldDomain $inputDomain --all-tables --allow-root &>/dev/null

  textYellow "----------------> INSTALL VIRTUALHOST"

  echo ''

  createVirtualHost $inputDomain

  updateHTTPConfig

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  rm index.html &>/dev/null

  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html &>/dev/null

  textYellow "----------------> INSTALL SSL/HTTPS"

  certbot certonly --non-interactive --agree-tos -m root@localhost --webroot -w $UNKNOWN_DIR/$inputDomain/html -d $inputDomain &>/dev/null

  echo ''

  restartWebserver
}

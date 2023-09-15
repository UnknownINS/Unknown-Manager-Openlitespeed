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

  echo ''

  if  [[ -z "$urlDatabase" ]] || [[ -z "$urlCodeBackup" ]] || [[ -z "$oldDomain" ]] || [[ -z "$inputDomain" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    echo ''
    exit
  fi

  verifyExitDir $UNKNOWN_DIR/$inputDomain

  baseNameCode=$(basename $urlCodeBackup)

  baseNameSQL=$(basename $urlDatabase)

  nameDatabase=$(sed "s/\./_/g" <<<"$inputDomain")

  if [[ -z "$nameDatabase" ]] || [[ -z "$baseNameSQL" ]] || [[ -z "$baseNameCode" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    echo ''
    exit
  fi

  cd /home || exit

  textYellow "----------------> DOWNLOAD CODE BACKUP"

  echo ''

  wget $urlCodeBackup

  textYellow "----------------> DOWNLOAD SQL BACKUP"

  echo ''

  wget $urlDatabase

  textYellow "----------------> INSTALL BACKUP"

  echo ''

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

  certbot certonly --non-interactive --agree-tos -m admin@gmail.com --webroot -w $UNKNOWN_DIR/$inputDomain/html -d $inputDomain &>/dev/null

  echo ''

  restartWebserver
}

#!/bin/bash

restoreRemote() {

  verifyMariadb

  verifyConstainDatabase

  textYellow "----------------> RESTORE REMOTE"

  read -p "----------------> New Domain Name : " inputDomain

  read -p "----------------> Old Domain Name : " oldDomain

  read -p "----------------> URL Code Backup (.zip) : " urlCodeBackup

  read -p "----------------> URL Database Backup (.sql) : " urlDatabase

  if  [[ -z "$urlDatabase" ]] || [[ -z "$urlCodeBackup" ]] || [[ -z "$oldDomain" ]] || [[ -z "$inputDomain" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    exit
  fi

  verifyExitDir $UNKNOWN_DIR/$inputDomain

  baseNameCode=$(basename $urlCodeBackup)

  baseNameSQL=$(basename $urlDatabase)

  nameDatabase=$(sed "s/\./_/g" <<<"$inputDomain")

  if [[ -z "$nameDatabase" ]] || [[ -z "$baseNameSQL" ]] || [[ -z "$baseNameCode" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    exit
  fi

  cd /home || exit

  textYellow "----------------> DOWNLOAD CODE BACKUP"


  wget $urlCodeBackup

  textYellow "----------------> DOWNLOAD SQL BACKUP"

  wget $urlDatabase

  textYellow "----------------> INSTALL BACKUP"


  createDatabase $nameDatabase &>/dev/null

  PRIVATE_SQL_PASSWORD_DOMAIN=$(openssl rand -base64 15);

  createUserDatabase $nameDatabase $PRIVATE_SQL_PASSWORD_DOMAIN

  GrantingSQLUserPermissions $nameDatabase $nameDatabase

  FlushMYSQL

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

  wp config set DB_HOST "localhost" --allow-root &>/dev/null
  wp config set DB_NAME "$nameDatabase" --allow-root &>/dev/null
  wp config set DB_USER "$nameDatabase" --allow-root &>/dev/null
  wp config set DB_PASSWORD "$PRIVATE_SQL_PASSWORD_DOMAIN" --allow-root &>/dev/null
  wp search-replace $oldDomain $inputDomain --all-tables --allow-root &>/dev/null

  textYellow "----------------> INSTALL VIRTUALHOST"

  createVirtualHost $inputDomain

  updateHTTPConfig

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  rm index.html &>/dev/null

  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html &>/dev/null

  textYellow "----------------> INSTALL SSL/HTTPS"

  installSslCLI $inputDomain

  restartWebserver
}

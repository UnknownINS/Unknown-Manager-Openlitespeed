#!/bin/bash

restoreRemote(){

  echo ''

  verifyMariadb

  textYellow "----------------> RESTORE REMOTE"

  echo ''

  read -p "----------------> Domain Name : " inputDomain

  echo ''

  read -p "----------------> URL Code Backup (.zip) : " urlCodeBackup

    echo ''

  read -p "----------------> URL Database Backup (.sql) : " urlDatabase

  echo ''

  verifyExitDir $UNKNOWN_DIR/$inputDomain

  textYellow "----------------> DOWNLOAD REMOTE"

  echo ''

  cd /home || exit

  baseNameCode=$(basename $urlCodeBackup)

  baseNameSQL=$(basename $urlDatabase)

  curl -o $urlCodeBackup

  curl -o $urlDatabase

  textYellow "----------------> INSTALL BACKUP"

  echo ''

    nameDatabase=$(sed "s/\./_/g" <<< "$inputDomain")

    createDatabase $nameDatabase &>/dev/null

    mkdir -p $UNKNOWN_DIR/$inputDomain/html

    cd $UNKNOWN_DIR/$inputDomain/html || exit

    mv /home/$baseNameCode $UNKNOWN_DIR/$inputDomain/html

    mv /home/sql_restore.sql $UNKNOWN_DIR/$inputDomain/html

    unzip $baseNameCode &> /dev/null

    rm $baseNameCode &> /dev/null

    importDatabase $nameDatabase $UNKNOWN_DIR/$inputDomain/html/$baseNameSQL

    rm $UNKNOWN_DIR/$inputDomain/html/sql_restore.sql

    textMagenta "----------------> RESTORE REMOTE SUCCESS"

    echo ''
}
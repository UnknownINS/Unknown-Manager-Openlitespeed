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

  curl -o code_restore.zip $urlCodeBackup

  curl -o sql_restore.sql $urlDatabase

    nameDatabase=$(sed "s/\./_/g" <<< "$inputDomain")

    createDatabase $nameDatabase &>/dev/null

    mkdir -p $UNKNOWN_DIR/$inputDomain/html

    cd $UNKNOWN_DIR/$inputDomain/html || exit

    mv /home/code_restore.zip $UNKNOWN_DIR/$inputDomain/html

    mv /home/sql_restore.sql $UNKNOWN_DIR/$inputDomain/html

    unzip code_restore.zip

    cp -rf code_restore/* ./

    rm -rf code_restore/*

    importDatabase $nameDatabase $UNKNOWN_DIR/$inputDomain/html/sql_restore.sql

    rm $UNKNOWN_DIR/$inputDomain/html/sql_restore.sql

    textMagenta "----------------> RESTORE REMOTE SUCCESS"

    echo ''

}
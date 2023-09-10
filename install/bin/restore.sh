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

    nameDatabase=$(sed "s/\./_/g" <<< "$inputDomain")

    createDatabase $nameDatabase &>/dev/null

    mkdir -p $UNKNOWN_DIR/$inputDomain/html

    cd $UNKNOWN_DIR/$inputDomain/html || exit

    mv /home/$baseNameCode $UNKNOWN_DIR/$inputDomain/html

    mv /home/$baseNameSQL $UNKNOWN_DIR/$inputDomain/html

    unzip $baseNameCode &> /dev/null

    rm $baseNameCode &> /dev/null

    getFileName=${baseNameCode%.*}

    cp -r $getFileName/* ./

    rm -rf $getFileName

    importDatabase $nameDatabase $UNKNOWN_DIR/$inputDomain/html/$baseNameSQL

    rm $UNKNOWN_DIR/$inputDomain/html/$baseNameSQL

    textMagenta "----------------> RESTORE REMOTE SUCCESS"

    echo ''
}
#!/bin/bash

restoreRemote(){

  echo ''

  verifyMariadb

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

    nameDatabase=$(sed "s/\./_/g" <<< "$inputDomain")

    createDatabase $nameDatabase &>/dev/null

    mkdir -p $UNKNOWN_DIR/$inputDomain/html

    cd $UNKNOWN_DIR/$inputDomain/html || exit

    mv /home/$baseNameCode $UNKNOWN_DIR/$inputDomain/html

    mv /home/$baseNameSQL $UNKNOWN_DIR/$inputDomain/html

    unzip $baseNameCode &> /dev/null

    rm $baseNameCode &> /dev/null

    getFileName=${baseNameCode%.*}

    cp -r $getFileName/* ./ &> /dev/null

    rm -rf $getFileName &> /dev/null

    importDatabase $nameDatabase $UNKNOWN_DIR/$inputDomain/html/$baseNameSQL

    rm $UNKNOWN_DIR/$inputDomain/html/$baseNameSQL &> /dev/null

    wp search-replace $oldDomain $inputDomain --all-tables --allow-root

    wp core config --dbhost=localhost --dbname=$nameDatabase --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --allow-root &>/dev/null

    textMagenta "----------------> RESTORE REMOTE SUCCESS"

    echo ''
}
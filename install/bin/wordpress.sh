#!/bin/bash

wpCreateWebsite() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyCertbot

  verifyConstainDatabase

  read -p "----------------> Enter Domain : " inputDomain

  validate="^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$"

  if [[ -z "$inputDomain" ]]; then

    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"

    exit
  fi

  verifyExitDir $UNKNOWN_DIR/$inputDomain

  if [[ "$inputDomain" =~ $validate ]]; then
    textYellow "----------------> CREATE DATABASE FOR WEBSITE"
  else
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi

  nameDatabase=$(sed "s/\./_/g" <<<"$inputDomain")
  nameDatabase=$(sed "s/\-/_/g" <<<"$nameDatabase")

  createDatabase $nameDatabase &>/dev/null

  mkdir -p $UNKNOWN_DIR/$inputDomain/html

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  textYellow "----------------> DOWNLOAD WORDPRESS CORE"

  wp core download --allow-root &>/dev/null

  textYellow "----------------> WORDPRESS CORE CONFIG"

  PRIVATE_SQL_PASSWORD_DOMAIN=$(openssl rand -base64 15);

  createUserDatabase $nameDatabase $PRIVATE_SQL_PASSWORD_DOMAIN

  GrantingSQLUserPermissions $nameDatabase $nameDatabase

  FlushMYSQL

  wp core config --dbhost=localhost --dbname=$nameDatabase --dbuser=$nameDatabase --dbpass=$PRIVATE_SQL_PASSWORD_DOMAIN --allow-root &>/dev/null

  textYellow "----------------> WORDPRESS CORE INSTALL"

  ADMIN_PASSWORD=$(openssl rand -base64 20)

  wp core install --url=$inputDomain --title="News Website" --admin_name=admin --admin_password=$ADMIN_PASSWORD --admin_email=admin@gmail.com --allow-root &>/dev/null

  textYellow "----------------> INSTALL VIRTUALHOST"

  createVirtualHost $inputDomain

  updateHTTPConfig

  rm $UNKNOWN_DIR/$inputDomain/html/.htaccess &>/dev/null

    contentHtaccess="RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]"

  cat >$UNKNOWN_DIR/$inputDomain/html/.htaccess <<EOF
    $contentHtaccess
EOF

  rm $UNKNOWN_DIR/$inputDomain/html/index.html &>/dev/null

  chown -R nobody:nogroup $UNKNOWN_DIR/$inputDomain/html

  restartWebserver

  textYellow "----------------> INSTALL SSL/HTTPS"

  installSslCLI $inputDomain

  cd $UNKNOWN_DIR || exit

  textMagenta "----------------> CREATE WEBSITE SUCCESS"

  restartWebserver

  textMagenta "----------------> PASSWORD ADMIN : $ADMIN_PASSWORD"

}

wpUpdateWebsite() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  textYellow "----------------> UPDATE WEBSITE"

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  for i in $ALLDOMAIN; do

    if [[ $i != "localhost" ]]; then

      textYellow "----------------> $i"

      chown -R nobody:nogroup $UNKNOWN_DIR/$i/html

      cd $UNKNOWN_DIR/$i/html || exit

      wp core update --allow-root &>/dev/null

      wp plugin update --all --allow-root &>/dev/null

    fi

  done

  textMagenta "----------------> UPDATE WEBSITE SUCCESS"

  RepairWordpress

}

wpDeleteWebsite() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase


  read -p "----------------> Input Domain : " inputDomain

  if [ -z "$inputDomain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi

  verifyDir $UNKNOWN_DIR/$inputDomain/html


  textYellow "----------------> DELETE WEBSITE"


  rm -rf $UNKNOWN_DIR/$inputDomain &>/dev/null

  rm -rf $LSWS_VHOSTS/$inputDomain &>/dev/null

  nameDatabase=$(sed "s/\./_/g" <<<"$inputDomain")
  nameDatabase=$(sed "s/\-/_/g" <<<"$nameDatabase")

  deleteDatabase $nameDatabase &>/dev/null

  deleteUserDatabase $nameDatabase &>/dev/null

  textYellow "----------------> UPDATE HTTP/HTTPS CONFIG"

  updateHTTPConfig

  restartWebserver
}

wpGetListUser() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  read -p "----------------> Input Domain : " inputDomain

  if [ -z "$inputDomain" ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi

  verifyDir $UNKNOWN_DIR/$inputDomain/html

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  wp user list --allow-root

}

wpResetPassword() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase


  read -p "----------------> Input Domain : " inputDomain

  read -p "----------------> Input User Login : " userLogin

  read -p "----------------> Input PassWord : " passWord

  if [[ -z "$inputDomain" ]] || [[ -z "$userLogin" ]] || [[ -z "$passWord" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    exit
  fi

  verifyDir $UNKNOWN_DIR/$inputDomain/html

  cd $UNKNOWN_DIR/$inputDomain/html || exit

  wp user update $userLogin --user_pass=$passWord --allow-root &>/dev/null

  textMagenta "----------------> UPDATE PASSWORD SUCCESS"

}

wpRenameDomain() {

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  read -p "----------------> New Domain : " newDomain

  read -p "----------------> Old Domain : " oldDomain

  if [[ -z "$newDomain" ]] || [[ -z "$oldDomain" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    exit
  fi

  verifyDir $oldDomain

  verifyExitDir $newDomain

  textYellow "----------------> RENAME DATABASE"

  databaseNewDomain=$(sed "s/\./_/g" <<<"$newDomain")
  databaseNewDomain=$(sed "s/\-/_/g" <<<"$databaseNewDomain")

  databaseOldDomain=$(sed "s/\./_/g" <<<"$oldDomain")
  databaseOldDomain=$(sed "s/\-/_/g" <<<"$databaseOldDomain")

  PRIVATE_SQL_PASSWORD_DOMAIN=$(openssl rand -base64 15);

  renameDataBase $databaseOldDomain $databaseNewDomain

  createUserDatabase $databaseNewDomain PRIVATE_SQL_PASSWORD_DOMAIN

  GrantingSQLUserPermissions $databaseNewDomain $databaseNewDomain

  deleteUserDatabase $databaseOldDomain &> /dev/null

  FlushMYSQL

  textYellow "----------------> RENAME DOMAIN"

  mv $oldDomain $newDomain

  cd $UNKNOWN_DIR/$newDomain/html || exit

  wp config set DB_HOST "localhost" --allow-root &>/dev/null

  wp config set DB_NAME "$databaseNewDomain" --allow-root &>/dev/null

  wp config set DB_USER "$databaseNewDomain" --allow-root &>/dev/null

  wp config set DB_PASSWORD "$PRIVATE_SQL_PASSWORD_DOMAIN" --allow-root &>/dev/null

  wp search-replace $oldDomain $newDomain --all-tables --allow-root &>/dev/null

  rm -rf $LSWS_VHOSTS/$oldDomain &>/dev/null

  createVirtualHost $newDomain

  cd $UNKNOWN_DIR/$newDomain/html || exit

  rm index.html &> /dev/null

  cd $UNKNOWN_DIR || exit

  updateHTTPConfig

  chown -R nobody:nogroup $UNKNOWN_DIR/$newDomain/html &>/dev/null

  restartWebserver

  installSslCLI $newDomain

  restartWebserver

}

wpRedirectDomain(){

  read -p "----------------> New Domain : " newDomain

  read -p "----------------> Old Domain : " oldDomain

  if [[ -z "$newDomain" ]] || [[ -z "$oldDomain" ]]; then
    textRed "----------------> PLEASE CHECK AGAIN"
    exit
  fi

  verifyDir $oldDomain

  textYellow "----------------> REDIRECT DOMAIN"

  cd $UNKNOWN_DIR/$oldDomain/html || exit

  rm .htaccess &> /dev/null

  rm index.html &> /dev/null

  contentHtaccess="
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteCond %{HTTP_HOST} ^$oldDomain$ [OR]
  RewriteCond %{HTTP_HOST} ^www.$oldDomain$
  RewriteRule (.*)$ https://$newDomain/\$1 [R=301,L]
</IfModule>
"

rm -rf $UNKNOWN_DIR/$oldDomain/html

mkdir -p $UNKNOWN_DIR/$oldDomain/html/

nameDatabase=$(sed "s/\./_/g" <<<"$oldDomain")

nameDatabase=$(sed "s/\-/_/g" <<<"$nameDatabase")

deleteDatabase $nameDatabase &>/dev/null

deleteUserDatabase $nameDatabase &>/dev/null

  cat >$UNKNOWN_DIR/$oldDomain/html/.htaccess <<EOF
$contentHtaccess
EOF

  cd $UNKNOWN_DIR || exit

  restartWebserver

}


RepairWordpress(){

  verifyExitOpenLiteSpeed

  verifyMariadb

  verifyConstainDatabase

  textYellow "----------------> REPAIR WEBSITE WORDPRESS"

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  for i in $ALLDOMAIN; do

    if [[ $i != "localhost" ]]; then

      cd $UNKNOWN_DIR/$i/html || exit

      wp config set WP_DEBUG false --raw --allow-root &> /dev/null

      wp config set FS_METHOD direct --allow-root &> /dev/null

      rm whitespacefix.php &> /dev/null

      cp $APP_INSTALL/library/whitespacefix.php whitespacefix.php

      findString=$(grep -r "whitespacefix" index.php)

       if [[ "$findString" =~ "whitespacefix" ]]; then
          textRed "-------------------> Nothing Changes $i"
          else
            sed -i 's/<?php/<?php\n\include ("whitespacefix.php");\n/g' index.php
            textBlue "-------------------> Update Success $i"
        fi
    fi

  done

  textMagenta "----------------> REPAIR WEBSITE SUCCESS"

}


toggleWPCRON(){

      textYellow "----------------> DISABLE/ENABLE WP CRON JOB ALL WEBSITE WORDPRESS"
      textMagenta "----------------> ENABLE = 1"
      textMagenta "----------------> DISABLE = 0"
      read -p "----------------> Input Number : " numberAction

      if [[ $numberAction == 1 ]] || [[ $numberAction == 0 ]]; then

        if [ $numberAction == 1 ]; then
          enableAllWPCRON
        else
          disableAllWPCRON
        fi

        else
          textRed "----------------> PLEASE CHECK INPUT TYPE"
      fi
}

disableAllWPCRON(){

    ALLDOMAIN=$(dir $UNKNOWN_DIR)

    for i in $ALLDOMAIN; do

      if [[ $i != "localhost" ]]; then

        textYellow "----------------> $i"
        cd $UNKNOWN_DIR/$i/html || exit
        wp config set DISABLE_WP_CRON true --raw --allow-root &> /dev/null

      fi

    done

    cd $UNKNOWN_DIR || exit

    textMagenta "----------------> DISABLE WP CRON SUCCESS"
}

enableAllWPCRON(){

    ALLDOMAIN=$(dir $UNKNOWN_DIR)

    for i in $ALLDOMAIN; do

      if [[ $i != "localhost" ]]; then

        textYellow "----------------> $i"
        cd $UNKNOWN_DIR/$i/html || exit
        wp config set DISABLE_WP_CRON false --raw --allow-root &> /dev/null

      fi

    done

    cd $UNKNOWN_DIR || exit

    textMagenta "----------------> ENABLE WP CRON SUCCESS"
}


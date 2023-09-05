#!/bin/bash

installPhpmyadmin(){

   verifyExitOpenLiteSpeed

   if [ -d "$UNKNOWN_DIR/localhost/html/sqlAdminManager" ]; then
      textMagenta "____________________ EXITS PHPMYADMIN ____________________"
    else
    textYellow "_______________________ DOWNLOAD PHPMYADMIN _______________________"
      mkdir -p "$UNKNOWN_DIR/localhost/html"
      cd "$UNKNOWN_DIR/localhost/html" || exit
      curl -o phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
      unzip phpmyadmin.zip &> /dev/null
      mv phpMyAdmin-5.2.1-all-languages sqlAdminManager
      rm phpmyadmin.zip
      echo "";
      restartWebserver
      chown -R nobody:nogroup "$UNKNOWN_DIR/localhost/html/sqlAdminManager"
      textMagenta "____________________ SUCCESS INSTALL _____________________"
      echo "URL PHPMYADMIN : http://$GET_IP_NAME/sqlAdminManager"
      cd "$UNKNOWN_DIR" || exit
    fi
    echo "";

   cd $UNKNOWN_DIR || exit

}


verifyMariadb(){

   UP=$(pgrep mariadb | wc -l);

if [ "$UP" -ne 1 ]; then
   textRed "Mariadb Error.Please try again later"
   echo ''
   exit
fi

}

MariadbSecure(){

verifyMariadb

textYellow "----------------> MARIADB SECURITY"

mysql_secure_installation

sudo systemctl restart mariadb &> /dev/null

echo "";

textMagenta "_____________ MARIADB SECURITY SUCCESS ____________"

echo ''
}


uninstallMariaDb(){

   cd "/" || exit

   textYellow "----------------> UNINSTALL MARIADB"

   echo ''

   verifyMariadb

   sudo apt-get purge mariadb* -y

   sudo apt --fix-broken install &> /dev/null

   sudo apt --fix-broken install &> /dev/null

   textMagenta "_____________ UNINSTALL MARIADB SUCCESS ____________"
   echo ''

}


createDatabase(){
$MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE $1;"
}


backupDatabase(){

   mkdir -p $1

   databases=`$MYSQL_BIN --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)"`
    
   for db in $databases; do

   $MYSQL_DUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$1/$db.sql.gz"
   done

}
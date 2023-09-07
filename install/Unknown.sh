#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

NUMBER_ACTION=-1

mkdir -p $UNKNOWN_DIR

mkdir -p $APP_INSTALL

cd "$UNKNOWN_DIR" || exit

setVariablesSystem

welcome

killAptGet

exitApp(){
  NUMBER_ACTION=0 &> /dev/null
}


defaultAction(){
NUMBER_ACTION=-1
textRed "----------------> PLEASE CHECK AGAIN"
echo ''
}


StartApp(){

echo "";
textGreen "0 ) Exit App                                    1 ) Install WebServer"

textGreen "2 ) Uninstall WebServer                         3 ) Config WebServer"

textGreen "4 ) Insert Phpmyadmin                           5 ) Config Auto Backup"

textGreen "6 ) Backup VPS.                                 7 ) Update Website Wordpress"

textGreen "8 ) Create Website Wordpress                    9 ) Restart WebServer"

textGreen "10) Update WebServer                            11) Mysql Config"

textGreen "12) Protect WebServer                           13) Reset Password WebAdmin";

textGreen "14) Uninstall MariaDb                           15) Install SSL/HTTPS for Domain";

textGreen "16) Config Auto Job                             17) Backup Google Driver Now";

textGreen "18) Renews SSL/HTTPS NOW                        19) Install Only Tool Support";

echo "";

read -p "----------------> ENTER NUMBER ACTION : " NUMBER_ACTION

echo "";

case $NUMBER_ACTION in

  0) exitApp;;

  1) installApp;;

  2) uninstallApp;;

  3) configWebServer;;

  4) installPhpmyadmin;;

  5) configAutoBackup;;

  6) backupVPS;;

  7) WPUpdateWebsite;;

  8) WPCreateWebsite;;

  9) restartWebserver;;

  10) updateWebserver;;

  11) MariadbSecure;;

  12) chownProtect;;

  13) resetWebadminPassword;;

  14) uninstallMariaDb;;

  15) installSslForDomain;;

  16) configAutoJob;;

  17) backupDriverNow;;

  18) renewSSLNow;;

  19) installToolSupport;;

  *) defaultAction;;

esac

}

while [ $NUMBER_ACTION -ne 0 ]
  do
    StartApp
done
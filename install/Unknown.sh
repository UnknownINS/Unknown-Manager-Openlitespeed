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

exitConsole(){
  NUMBER_ACTION=0 &> /dev/null
}


defaultAction(){
NUMBER_ACTION=-1
textRed "----------------> PLEASE CHECK AGAIN"
echo ''
}


StartApp(){

echo "";
textGreen "0 ) Exit App.                                   1 ) Install WebServer."

textGreen "2 ) Uninstall WebServer.                        3 ) Config WebServer."

textGreen "4 ) Insert Phpmyadmin.                          5 ) Config Auto Backup."

textGreen "6 ) Backup Local.                               7 ) Update Website."

textGreen "8 ) Create New Website.                         9 ) Restart WebServer."

textGreen "10) Update WebServer.                           11) Mysql Config."

textGreen "12) Security Website.                           13) Reset Password WebAdmin";

textGreen "14) Uninstall MariaDb.                          15) Install SSL/HTTPS for Domain";

textGreen "16) Config Auto Job.                            17) Backup Google Driver Now";

textGreen "18) Renews SSL/HTTPS NOW                        19) Install Library WebServer";

echo "";

read -p "----------------> ENTER NUMBER ACTION : " NUMBER_ACTION

echo "";

case $NUMBER_ACTION in

  0) exitConsole;;

  1) installWebServer;;

  2) uninstallWebServer;;

  3) configWebServer;;

  4) installPhpmyadmin;;

  5) configAutoBackup;;

  6) backupLocal;;

  7) wpUpdateWebsite;;

  8) wpCreateWebsite;;

  9) restartWebserver;;

  10) updateWebserver;;

  11) MariadbSecure;;

  12) securityWebServer;;

  13) resetAdminPassword;;

  14) uninstallMariaDb;;

  15) installSslForDomain;;

  16) configAutoJob;;

  17) backupDriver;;

  18) renewSSLNow;;

  19) installLibraryWebServer;;

  *) defaultAction;;

esac

}

while [ $NUMBER_ACTION -ne 0 ]
  do
    StartApp
done
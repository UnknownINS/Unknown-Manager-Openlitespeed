#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

NUMBER_ACTION=-1

mkdir -p $UNKNOWN_DIR

mkdir -p $APP_INSTALL

cd "$UNKNOWN_DIR" || exit

setVariablesSystem

welcome

killApt

exitConsole(){
  NUMBER_ACTION=0 &> /dev/null
}


defaultAction(){
NUMBER_ACTION=-1
textRed "----------------> PLEASE CHECK AGAIN"
echo ''
}


StartApp(){

echo ""

textYellow "----------------> WEBSERVER";

textGreen "0 ) Exit App.                                   1 ) Install WebServer."

textGreen "2 ) Uninstall WebServer.                        3 ) Config WebServer."

textGreen "4 ) Insert Phpmyadmin.                          5 ) Config Auto Backup."

textGreen "6 ) Backup Local.                               7 ) Update WebServer."
echo ''
textBlue "----------------> MANAGER WEBSITE";

textGreen "8 ) Create New Website.                         9 ) Delete WebSite."

textGreen "10) Restart WebServer.                          11) Update Website"

textGreen "12) Mysql Config.                               13) Security Website."

textGreen "14) Reset Password WebAdmin.                    15) Uninstall MariaDb.";

echo ''
textYellow "----------------> TOOL";

textGreen "16) Install SSL/HTTPS for Domain.               17) Config Auto Job.";

textGreen "18) Backup Google Driver Now.                   19) Renews SSL/HTTPS NOW.";

textGreen "20) Install Library WebServer.                  21) Show All Domain.";

textGreen "22) Restore Remote.                             23) Permission Public Domain.";

echo ''
textMagenta "----------------> ABOUT AUTO";

textGreen "24) Uninstall Unknown OLS.                      25) Update UNKNOWN OLS.";

echo ''

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

  7) updateWebserver;;

  8) wpCreateWebsite;;

  9) wpDeleteWebsite;;

  10) restartWebserver;;

  11) wpUpdateWebsite;;

  12) MariadbSecure;;

  13) securityWebServer;;

  14) resetAdminPassword;;

  15) uninstallMariaDb;;

  16) installSslForDomain;;

  17) configAutoJob;;

  18) backupDriver;;

  19) renewSSLNow;;

  20) installLibraryWebServer;;

  21) getAllDomain;;

  22) restoreRemote;;

  23) chownNobodyDomain;;

  24) uninstallUnknownOLS;;

  25) updateUnknownOLS;;

  *) defaultAction;;

esac

}

while [ $NUMBER_ACTION -ne 0 ]
  do
    StartApp
done
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

exitConsole() {
  NUMBER_ACTION=0 &>/dev/null
}

defaultAction() {
  NUMBER_ACTION=-1
  textRed "----------------> PLEASE CHECK AGAIN"
  echo ''
}

StartApp() {

  echo ""

  textYellow "----------------> WEBSERVER"

  textGreen "0 ) Exit App.                                   1 ) Install WebServer."

  textGreen "2 ) Uninstall WebServer.                        3 ) Config WebServer."

  textGreen "4 ) Insert Phpmyadmin.                          5 ) Config Rclone."

  textGreen "6 ) Backup Local.                               7 ) Update WebServer."

  textGreen "8 ) Mysql Config.                               9 ) Uninstall MariaDb."

  textGreen "10) Backup Google Driver Now.                   11) Install Library WebServer."

  textGreen "12) Restart WebServer.                          13) Reset Password WebAdmin."

  textGreen "14) Update HTTP Config."

  echo ''
  textBlue "----------------> MANAGER WEBSITE"

  textGreen "15) Create New Website.                         16) Delete WebSite."

  textGreen "17) Update Website.                             18) Security Website."

  textGreen "19) Reset password User (for WordPress).        20) Show All Domain."

  textGreen "21) Get List User (for WordPress).              22) Permission Public Domain."

  echo ''
  textYellow "----------------> TOOL"

  textGreen "23) Install SSL/HTTPS for Domain.               24) Config Auto Job."

  textGreen "25) Renews SSL/HTTPS NOW.                       26) Restore Remote."

  textGreen "27) Rename Domain.                              28) Redirect Domain."

  textGreen "29) Repair DataBase.                            30) Disable Firewall."

  echo ''
  textMagenta "----------------> ABOUT AUTO"

  textGreen "31) Uninstall Unknown OLS.                      32) Update UNKNOWN OLS."

  echo ''

  read -p "----------------> ENTER NUMBER ACTION : " NUMBER_ACTION

  echo ""

  case $NUMBER_ACTION in

  0) exitConsole ;;

  1) installWebServer ;;

  2) uninstallWebServer ;;

  3) configWebServer ;;

  4) installPhpmyadmin ;;

  5) configAutoBackup ;;

  6) backupLocal ;;

  7) updateWebserver ;;

  8) MariadbSecure ;;

  9) uninstallMariaDb ;;

  10) backupDriver ;;

  11) installLibraryWebServer ;;

  12) restartWebserver ;;

  13) resetAdminPassword ;;

  14) updateDomainSever ;;

  15) wpCreateWebsite ;;

  16) wpDeleteWebsite ;;

  17) wpUpdateWebsite ;;

  18) securityWebServer ;;

  19) wpResetPassword ;;

  20) getAllDomain ;;

  21) wpGetListUser ;;

  22) chownNobodyDomain ;;

  23) installSslForDomain ;;

  24) configAutoJob ;;

  25) renewSSLNow ;;

  26) restoreRemote ;;

  27) wpRenameDomain ;;

  28) wpRedirectDomain ;;

  29) repairDatabases ;;

  30) disableFirewall ;;

  31) uninstallUnknownOLS ;;

  32) updateUnknownOLS ;;

  *) defaultAction ;;

  esac

}

while [ $NUMBER_ACTION -ne 0 ]; do
  StartApp
done

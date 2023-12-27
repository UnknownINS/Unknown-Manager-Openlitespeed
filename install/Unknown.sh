#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

NUMBER_ACTION=-1

EVENT_ACTION=-1

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

backToMainScreen() {
  clear
  NUMBER_ACTION=-1
  EVENT_ACTION=-1
  echo ''
}

defaultEventUNK(){
    clear
    EVENT_ACTION=$1
    textRed "----------------> PLEASE CHECK AGAIN"
    echo ''
}

WebServerScreen(){

    clear

    echo ""

    textYellow "----------------> WEBSERVER"

    textGreen "0 ) Back To App.                                1 ) Install WebServer."

    textGreen "2 ) Uninstall WebServer.                        3 ) Config WebServer."

    textGreen "4 ) Insert Phpmyadmin.                          5 ) Config Rclone."

    textGreen "6 ) Backup Local.                               7 ) Update WebServer."

    textGreen "8 ) Mysql Config.                               9 ) Uninstall MariaDb."

    textGreen "10) Backup Google Driver Now.                   11) Install Library WebServer."

    textGreen "12) Restart WebServer.                          13) Reset Password WebAdmin."

    textGreen "14) Reload HTTP/HTTPS Config                    15) Config Variable OpenLiteSpeed"

    echo ''

    read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION

    echo ""

      case $EVENT_ACTION in

      0) backToMainScreen ;;

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

      15) configVariableOpenLiteSpeed ;;

      *) defaultEventUNK 44 ;;

      esac

}

StartApp() {

  echo ""

  textYellow "----------------> WEBSERVER"

  textGreen "44 ) WebSerVer"


  textGreen "0 ) Exit App.                                   1 ) Install WebServer."

  textGreen "2 ) Uninstall WebServer.                        3 ) Config WebServer."

  textGreen "4 ) Insert Phpmyadmin.                          5 ) Config Rclone."

  textGreen "6 ) Backup Local.                               7 ) Update WebServer."

  textGreen "8 ) Mysql Config.                               9 ) Uninstall MariaDb."

  textGreen "10) Backup Google Driver Now.                   11) Install Library WebServer."

  textGreen "12) Restart WebServer.                          13) Reset Password WebAdmin."

  textGreen "14) Reload HTTP/HTTPS Config                    15) Config Variable OpenLiteSpeed"

  echo ''
  textBlue "----------------> MANAGER WEBSITE"

  textGreen "16) Create New Website.                         17) Delete WebSite."

  textGreen "18) Update Website.                             19) Security Website."

  textGreen "20) Reset password User (for WordPress).        21) Show All Domain."

  textGreen "22) Get List User (for WordPress).              23) Permission Public Domain."

  echo ''
  textYellow "----------------> TOOL"

  textGreen "24) Install SSL/HTTPS for Domain.               25) Config Auto Job."

  textGreen "26) Renews SSL/HTTPS NOW.                       27) Restore Remote."

  textGreen "28) Rename Domain.                              29) Redirect Domain."

  textGreen "30) Repair DataBase.                            31) Disable Firewall."

  textGreen "32) Enable Firewall.                            33) Repair Wordpress."

  textGreen "34) Install NetData.                            35) Uninstall NetData"

  textGreen "36) Install FTP for Domain.                     37) Delete FTP Domain"

  textGreen "38) Disable/Enable Cron Job All Website         39) Check System"

  textGreen "40) Check Use Hard Drive                        41) Optimize Image for Website"

  echo ''
  textMagenta "----------------> ABOUT TOOL"

  textGreen "42) Uninstall Unknown OLS.                      43) Update UNKNOWN OLS."

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

  15) configVariableOpenLiteSpeed ;;

  16) wpCreateWebsite ;;

  17) wpDeleteWebsite ;;

  18) wpUpdateWebsite ;;

  19) securityWebServer ;;

  20) wpResetPassword ;;

  21) getAllDomain ;;

  22) wpGetListUser ;;

  23) chownNobodyDomain ;;

  24) installSslForDomain ;;

  25) configAutoJob ;;

  26) renewSSLNow ;;

  27) restoreRemote ;;

  28) wpRenameDomain ;;

  29) wpRedirectDomain ;;

  30) repairDatabases ;;

  31) disableFirewall ;;

  32) enableFirewall ;;

  33) RepairWordpress ;;

  34) installNetData ;;

  35) unInstallNetData ;;

  36) installFTPForDomain ;;

  37) deleteFTPDomain ;;

  38) toggleWPCRON ;;

  39) checkSystem ;;

  40) checkUseHardDrive ;;

  41) optimizeImage ;;

  42) uninstallUnknownOLS ;;

  43) updateUnknownOLS ;;

  44) WebServerScreen ;;

  *) defaultAction ;;

  esac

}

while [ $NUMBER_ACTION -ne 0 ]; do
  StartApp
done

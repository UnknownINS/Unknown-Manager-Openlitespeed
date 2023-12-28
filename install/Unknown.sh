#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

NUMBER_ACTION=-1

mkdir -p $UNKNOWN_DIR

mkdir -p $APP_INSTALL

cd "$UNKNOWN_DIR" || exit

setVariablesSystem

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
  echo ''
}

setAction(){
   NUMBER_ACTION=$1
}

WebServerScreen(){
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

      *) WebServerScreen ;;

      esac

}

ManagerWebSiteScreen(){
  echo ""

  textYellow "----------------> MANAGER WEBSITE"

    textGreen "0 ) Back To App.                                1 ) Create New Website."

    textGreen "2 ) Delete WebSite.                             3 ) Update Website."

    textGreen "4 ) Security Website.                           5 ) Reset password User."

    textGreen "6 ) Show All Domain.                            7 ) Get List User."

    textGreen "8 ) Permission Public Domain."

    echo ''

    read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION

    echo ""

      case $EVENT_ACTION in
      0) backToMainScreen ;;
      1) wpCreateWebsite ;;
      2) wpDeleteWebsite ;;
      3) wpUpdateWebsite ;;
      4) securityWebServer ;;
      5) wpResetPassword ;;
      6) getAllDomain ;;
      7) wpGetListUser ;;
      8) chownNobodyDomain ;;
      *) ManagerWebSiteScreen ;;
      esac

}
ExtendToolScreen(){
  echo ""
  textYellow "----------------> Extend Tool"

  textGreen "0 ) Back To App.                               1 ) Install SSL/HTTPS."

  textGreen "2 ) Config Auto Job.                           3 ) Renews SSL/HTTPS."

  textGreen "4 ) Restore Remote.                            5 ) Rename Domain."

  textGreen "6 ) Redirect Domain.                           7 ) Repair DataBase."

  textGreen "8 ) Disable Firewall.                          9 ) Enable Firewall."

  textGreen "10 ) Repair Wordpress.                        11 ) Install NetData."

  textGreen "12 ) Uninstall NetData.                       13 ) Add FTP."

  textGreen "14 ) Delete FTP.                              15 ) Disable/Enable Cron Job"

  echo ''
  read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
  echo ""
  case $EVENT_ACTION in
      0) backToMainScreen ;;
      1) installSslForDomain ;;
      2) configAutoJob ;;
      3) renewSSLNow ;;
      4) restoreRemote ;;
      5) wpRenameDomain ;;
      6) wpRedirectDomain ;;
      7) repairDatabases ;;
      8) disableFirewall ;;
      9) enableFirewall ;;
      10) RepairWordpress ;;
      11) installNetData ;;
      12) unInstallNetData ;;
      13) installFTPForDomain ;;
      14) deleteFTPDomain ;;
      15) toggleWPCRON ;;
      *) ExtendToolScreen ;;
  esac

}

HardDriveScreen(){
    echo ""
    textYellow "----------------> Hard Drive"

    textGreen "0 ) Back To App.                               1 ) About System."
    textGreen "2 ) About Hard Drive."

    echo ''
    read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
    echo ""
    case $EVENT_ACTION in
        0) backToMainScreen ;;
        1) checkSystem ;;
        2) checkUseHardDrive ;;
        *) HardDriveScreen ;;
    esac

}

OptimizeScreen(){
  echo ""
      textYellow "----------------> Optimize WebSite"

      textGreen "0 ) Back To App.                               1 ) Covert Image To WebP."

      echo ''
      read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
      echo ""
      case $EVENT_ACTION in
          0) backToMainScreen ;;
          1) optimizeImage ;;
          *) OptimizeScreen ;;
      esac
}

RunAppAction(){

  case $NUMBER_ACTION in
  0) exitConsole ;;
  1) WebServerScreen ;;
  2) ManagerWebSiteScreen ;;
  3) ExtendToolScreen ;;
  4) HardDriveScreen ;;
  5) OptimizeScreen ;;
  6) uninstallUnknownOLS ;;
  7) updateUnknownOLS ;;
  *) defaultAction ;;
  esac
}


StartApp() {
  welcome
  echo ""
  textRed "----------------> TOOL MANAGER"
  textGreen "0 ) Exit App.                                   1 ) Manager WebServer."
  textGreen "2 ) Manager WebSite.                            3 ) Extend Tool."
  textGreen "4 ) Hard Drive.                                 5 ) Optimize WebSite."
  echo ''
  textRed "----------------> ABOUT TOOL"
  textGreen "6 ) Uninstall OLS.                              7 ) Update OLS."
  echo ''
  read -p "----------------> ENTER NUMBER ACTION : " NUMBER_ACTION
  echo ""
  RunAppAction
}

while [ $NUMBER_ACTION -ne 0 ]; do
  if [ $NUMBER_ACTION != -1 ]; then
    RunAppAction
    else
      StartApp
  fi
done

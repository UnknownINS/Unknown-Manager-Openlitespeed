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
  NUMBER_ACTION=-1
  echo ''
}

setAction(){
   NUMBER_ACTION=$1
}

WebServerScreen(){

    echo ""

    textYellow "----------------> WEBSERVER MANAGER"

    textGreen "0 ) Back To App.                                1 ) Install WebServer."

    textGreen "2 ) Uninstall WebServer.                        3 ) Config WebServer."

    textGreen "4 ) Insert Phpmyadmin.                          5 ) Update WebServer."

    textGreen "6 ) Install Library WebServer.                  7 ) Restart WebServer."

    textGreen "8 ) Reset Password WebAdmin.                    9 ) Reload HTTP/HTTPS Config."

    textGreen "10) Config Variable OpenLiteSpeed."

    echo ''

    read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION

    echo ""

      case $EVENT_ACTION in

      0)
        clear
        backToMainScreen ;;
      1)
        clear
        installWebServer ;;
      2)
        clear
        uninstallWebServer ;;
      3)
        clear
        configWebServer ;;
      4)
        clear
        installPhpmyadmin ;;
      5)
        clear
        updateWebserver ;;
      6)
        clear
        installLibraryWebServer ;;
      7)
        clear
        restartWebserver ;;
      8)
        clear
        resetAdminPassword ;;
      9)
        clear
        updateDomainSever ;;
      10)
        clear
        configVariableOpenLiteSpeed ;;
      *)
        WebServerScreen ;;

      esac

}

ManagerWebSiteScreen(){

  echo ""

  textYellow "----------------> MANAGER WEBSITE"

    textGreen "0 ) Back To App.                                1 ) Create New Website."

    textGreen "2 ) Delete WebSite.                             3 ) Update Website."

    textGreen "4 ) Security Website.                           5 ) Show All Domain."

    textGreen "6 ) Nobody Domain.                              7 ) Rename Domain."

    textGreen "8 ) Redirect Domain."

    echo ''

    read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION

    echo ""

      case $EVENT_ACTION in
      0)
        clear
        backToMainScreen ;;
      1)
        clear
        wpCreateWebsite ;;
      2)
        clear
        wpDeleteWebsite ;;
      3)
        clear
        wpUpdateWebsite ;;
      4)
        clear
        securityWebServer ;;
      5)
        clear
        getAllDomain ;;
      6)
        clear
        chownNobodyDomain ;;
      7)
        clear
        wpRenameDomain ;;
      8)
        clear
        wpRedirectDomain ;;
      *)
        ManagerWebSiteScreen ;;
      esac

}

ExtendToolScreen(){
  echo ""
  textYellow "----------------> Extend Tool"

  textGreen "0 ) Back To App.                               1 ) Disable Firewall."

  textGreen "2 ) Enable Firewall.                           3 ) Install NetData."

  textGreen "4 ) Uninstall NetData."


  echo ''
  read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
  echo ""
  case $EVENT_ACTION in
      0)
        clear
        backToMainScreen ;;
      1)
        clear
        disableFirewall ;;
      2)
        clear
        enableFirewall ;;
      3)
        clear
        installNetData ;;
      4)
        clear
        unInstallNetData ;;
      *)
        ExtendToolScreen ;;
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
        0)
          clear
          backToMainScreen ;;
        1)
          clear
          checkSystem ;;
        2)
          clear
          checkUseHardDrive ;;
        *)
          HardDriveScreen ;;
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
          0)
            clear
            backToMainScreen ;;
          1)
            clear
            optimizeImage ;;
          *)
            OptimizeScreen ;;
      esac
}

BackupAndRestoreScreen(){
      echo ""
      textYellow "----------------> Backup and Restore"

      textGreen "0 ) Back To App.                               1 ) Backup Local."
      textGreen "2 ) Backup Google Driver.                      3 ) Restore Remote."

      echo ''
      read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
      echo ""
      case $EVENT_ACTION in
          0)
            clear
            backToMainScreen ;;
          1)
            clear
            backupLocal ;;
          2)
            clear
            backupDriver ;;
          3)
            clear
            restoreRemote ;;
          *)
            BackupAndRestoreScreen ;;
      esac
}


SslScreen(){
      echo ""
      textYellow "----------------> SSL TOOL"
      textGreen "0 ) Back To App.                               1 ) Install SSL/HTTPS."
      textGreen "2 ) Renews SSL/HTTPS."

      echo ''
      read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
      echo ""
      case $EVENT_ACTION in
          0)
            clear
            backToMainScreen ;;
          1)
            clear
            installSslForDomain ;;
          2)
            clear
            renewSSLNow ;;
          *)
            SslScreen ;;
      esac
}

CronJobScreen(){
      echo ""
      textYellow "----------------> CRON JOB TOOL"
      textGreen "0 ) Back To App.                              1 ) Config RClone."
      textGreen "2 ) Config Auto Job."

      echo ''
      read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
      echo ""
      case $EVENT_ACTION in
          0)
            clear
            backToMainScreen ;;
          1)
            clear
            configAutoBackup ;;
          2)
            clear
            configAutoJob ;;
          *)
            CronJobScreen ;;
      esac
}


dataBaseScreen(){
      echo ""
      textYellow "----------------> Database Manager"

      textGreen "0 ) Back To App.                              1 ) Mysql Config."
      textGreen "2 ) Uninstall MariaDb.                        3 ) Repair DataBase."

      echo ''
      read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
      echo ""
      case $EVENT_ACTION in
          0)
            clear
            backToMainScreen ;;
          1)
            clear
            MariadbSecure ;;
          2)
            clear
            uninstallMariaDb ;;
          3)
            clear
            repairDatabases ;;
          *)
            dataBaseScreen ;;
      esac
}


FTPScreen(){

      echo ""
      textYellow "----------------> FTP Manager"

      textGreen "0 ) Back To App.                              1 ) Add FTP."

      textGreen "2 ) Delete FTP."

      echo ''
      read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
      echo ""
      case $EVENT_ACTION in
          0)
            clear
            backToMainScreen ;;
          1)
            clear
            installFTPForDomain ;;
          2)
            clear
            deleteFTPDomain ;;
          *)
            FTPScreen ;;
      esac
}

WordpressScreen(){
      echo ""
      textYellow "----------------> Wordpress Manager"

      textGreen "0 ) Back To App.                              1 ) Repair Wordpress."
      textGreen "2 ) Reset Password User.                      3 ) Get User Wordpress."
      textGreen "4 ) Disable/Enable Cron Job."


      echo ''
      read -p "----------------> ENTER NUMBER ACTION : " EVENT_ACTION
      echo ""
      case $EVENT_ACTION in
          0)
            clear
            backToMainScreen ;;
          1)
            clear
            RepairWordpress ;;
          2)
            clear
            wpResetPassword ;;
          3)
            clear
            wpGetListUser ;;
          4)
            clear
            toggleWPCRON ;;
          *)
            FTPScreen ;;
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
  6) BackupAndRestoreScreen ;;
  7) SslScreen ;;
  8) CronJobScreen ;;
  9) dataBaseScreen ;;
  10) FTPScreen ;;
  11) WordpressScreen ;;
  12) uninstallUnknownOLS ;;
  13) updateUnknownOLS ;;
  *) defaultAction ;;
  esac
}

StartApp() {
  welcome
  echo ""
  textRed "----------------> TOOL MANAGER"
  textGreen "0 ) Exit App.                                   1 ) Manager WebServer."
  textGreen "2 ) Manager WebSite.                            3 ) Extend Tool."
  textGreen "4 ) Hard Drive System.                          5 ) Manager Optimize."
  textGreen "6 ) Backup and Restore.                         7 ) SSL Tool."
  textGreen "8 ) Cron Job.                                   9 ) Database Manager."
  textGreen "10) FTP Manager.                                11) Wordpress Tool."
  echo ''
  textRed "----------------> ABOUT TOOL"
  textGreen "12) Uninstall Unknown OLS.                      13) Update Unknown OLS."
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

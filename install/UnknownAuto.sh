#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

mkdir -p $UNKNOWN_DIR

mkdir -p $APP_INSTALL

cd "$UNKNOWN_DIR" || exit

setVariablesSystem

killApt

case $1 in
1) installWebServer ;;

2) uninstallWebServer ;;

3) configWebServer ;;

4) installPhpmyadmin ;;

5) configAutoBackup ;;

6) backupLocal ;;

7) updateWebserver ;;

8) wpCreateWebsite ;;

9) wpDeleteWebsite ;;

10) restartWebserver ;;

11) wpUpdateWebsite ;;

12) MariadbSecure ;;

13) securityWebServer ;;

14) resetAdminPassword ;;

15) uninstallMariaDb ;;

16) installSslForDomain ;;

17) configAutoJob ;;

18) backupDriver ;;

19) renewSSLNow ;;

20) installLibraryWebServer ;;

21) getAllDomain ;;

22) restoreRemote ;;

23) chownNobodyDomain ;;

24) wpGetListUser ;;

25) wpResetPassword ;;

26) uninstallUnknownOLS ;;

27) updateUnknownOLS ;;

esac

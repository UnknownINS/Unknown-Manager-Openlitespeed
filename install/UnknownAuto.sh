#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

mkdir -p $UNKNOWN_DIR

mkdir -p $APP_INSTALL

cd "$UNKNOWN_DIR" || exit

setVariablesSystem

killAptGet

case $1 in

0) exitApp ;;

1) installApp ;;

2) uninstallApp ;;

3) configWebServer ;;

4) installPhpmyadmin ;;

5) configAutoBackup ;;

6) backupVPS ;;

7) WPUpdateWebsite ;;

8) WPCreateWebsite ;;

9) restartWebserver ;;

10) updateWebserver ;;

11) MariadbSecure ;;

12) chownProtect ;;

13) resetWebadminPassword ;;

14) uninstallMariaDb ;;

15) installSslForDomain ;;

16) configAutoJob ;;

17) backupDriverNow ;;

18) renewSSLNow ;;

19) installToolSupport ;;

esac

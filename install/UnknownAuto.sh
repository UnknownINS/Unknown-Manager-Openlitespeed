#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

mkdir -p $UNKNOWN_DIR

mkdir -p $APP_INSTALL

cd "$UNKNOWN_DIR" || exit

setVariablesSystem

killAptGet

case $1 in

1) installWebServer ;;

2) uninstallWebServer ;;

3) configWebServer ;;

4) installPhpmyadmin ;;

5) configAutoBackup ;;

6) backupLocal ;;

7) wpUpdateWebsite ;;

8) wpCreateWebsite ;;

9) restartWebserver ;;

10) updateWebserver ;;

11) MariadbSecure ;;

12) securityWebServer ;;

13) resetAdminPassword ;;

14) uninstallMariaDb ;;

15) installSslForDomain ;;

16) configAutoJob ;;

17) backupDriver ;;

18) renewSSLNow ;;

19) installLibraryWebServer ;;

esac

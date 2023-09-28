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

esac

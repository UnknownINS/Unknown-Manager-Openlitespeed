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

37) uninstallUnknownOLS ;;

38) updateUnknownOLS ;;

esac

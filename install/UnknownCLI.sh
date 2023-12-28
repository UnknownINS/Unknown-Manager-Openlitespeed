#!/bin/bash
export APP_INSTALL=/usr/local/unknown
source $APP_INSTALL/loader.sh

mkdir -p $UNKNOWN_DIR

mkdir -p $APP_INSTALL

cd "$UNKNOWN_DIR" || exit

setVariablesSystem

killApt

case $1 in
# install webserver
1) installWebServer ;;

# uninstall webserver
2) uninstallWebServer ;;

# config web server
3) configWebServer ;;

# phpmyadmin
4) installPhpmyadmin ;;


# config auto backup
5) configAutoBackup ;;

# backup local
6) backupLocal ;;

# update web server
7) updateWebserver ;;

# mariadb
8) MariadbSecure ;;

# uninstall database
9) uninstallMariaDb ;;

# backup driver
10) backupDriver ;;

# install web server
11) installLibraryWebServer ;;

# restart web server
12) restartWebserver ;;

# reset admin password web server
13) resetAdminPassword ;;

# update domain server
14) updateDomainSever ;;

# config openlite speed
15) configVariableOpenLiteSpeed ;;

# create website
16) wpCreateWebsite ;;

# delete website
17) wpDeleteWebsite ;;

# update website
18) wpUpdateWebsite ;;

# security webserver
19) securityWebServer ;;

# wp reset password
20) wpResetPassword ;;

# get all domain
21) getAllDomain ;;

# get list user
22) wpGetListUser ;;

# public noby domain
23) chownNobodyDomain ;;

# install ssl for domain
24) installSslForDomain ;;

# config auto job
25) configAutoJob ;;

# renew ssl
26) renewSSLNow ;;

#restore remote
27) restoreRemote ;;

#rename domain
28) wpRenameDomain ;;

# redirect domain
29) wpRedirectDomain ;;

# repair database
30) repairDatabases ;;

#disable firewall
31) disableFirewall ;;

# enable firewall
32) enableFirewall ;;

#repair wp
33) RepairWordpress ;;

# install netData
34) installNetData ;;

# uninstall netData
35) unInstallNetData ;;

# install FTP for Domain
36) installFTPForDomain ;;

# delete FTP Domain
37) deleteFTPDomain ;;

#toogle wp cron
38) toggleWPCRON ;;

# check System
39) checkSystem ;;

# check user hard drive
40) checkUseHardDrive ;;

# optimize Image
41) optimizeImage ;;

# uninstall Unknown ols
42) uninstallUnknownOLS ;;

# update Unknown OLS
43) updateUnknownOLS ;;

esac

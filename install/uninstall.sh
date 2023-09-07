#!/bin/bash

uninstallApp(){

cd "/" || exit

notificationUninstall

textBlue "----------------> UNINSTALL WEBSERVER"

killall lsphp &> /dev/null

killall lshttpd &> /dev/null

systemctl stop lsws &> /dev/null

$LSWS_DIR/bin/lswsctrl stop &> /dev/null

sudo apt-get purge certbot openlitespeed php* lsphp* rclone* -y &> /dev/null

sudo rm /usr/local/bin/wp &> /dev/null

sudo apt autoremove -y &> /dev/null

sudo rm -rf $LSWS_DIR &> /dev/null

sudo apt autoclean -y &> /dev/null

echo "";

sudo apt --fix-broken install &> /dev/null

textMagenta "_____________ UNINSTALL WEBSERVER SUCCESS ____________"

echo ''
}

#!/bin/bash

uninstallUnknownOLS() {

  echo ''

  sudo rm -rf $APP_INSTALL &>/dev/null

  textMagenta "----------------> UNINSTALL SUCCESS"

  echo ''

  exit
}

updateUnknownOLS(){

  cd /usr/local || exit

  sudo rm -rf $APP_INSTALL &>/dev/null

  git clone https://github.com/UnknownINS/Unknown-Manager-Openlitespeed.git && cd Unknown-Manager-Openlitespeed && bash install.sh &> /dev/null

  cd /usr/local || exit

  rm -rf Unknown-Manager-Openlitespeed

  echo ''

  textMagenta "----------------> UPDATE SUCCESS"

  echo ''

  Unknown
}

killApt() {
  sudo killall apt apt-get &>/dev/null
  sudo rm /var/lib/apt/lists/lock &>/dev/null
  sudo rm /var/cache/apt/archives/lock &>/dev/null
  sudo rm /var/lib/dpkg/lock* &>/dev/null
}

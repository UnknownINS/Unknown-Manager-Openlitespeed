#!/bin/bash

uninstallUnknownOLS() {

  sudo rm -rf $APP_INSTALL &>/dev/null

  textMagenta "----------------> UNINSTALL SUCCESS"
  exit
}

updateUnknownOLS() {

  cd /usr/local || exit

  sudo rm -rf $APP_INSTALL &>/dev/null

  git clone https://github.com/UnknownINS/Unknown-Manager-Openlitespeed.git && cd Unknown-Manager-Openlitespeed && bash install.sh &>/dev/null

  cd /usr/local || exit

  rm -rf Unknown-Manager-Openlitespeed  &>/dev/null

  textMagenta "----------------> UPDATE SUCCESS"

  exit

}

killApt() {
  sudo killall apt apt-get &>/dev/null
  sudo rm /var/lib/apt/lists/lock &>/dev/null
  sudo rm /var/cache/apt/archives/lock &>/dev/null
  sudo rm /var/lib/dpkg/lock* &>/dev/null
}

getAllDomain() {

  ALLDOMAIN=$(dir $UNKNOWN_DIR)

  cd $UNKNOWN_DIR || exit

  for i in $ALLDOMAIN; do

    if [ $i != "localhost" ]; then
      textYellow "----> $i"
    fi

  done

}

verifyExitDir() {

  if [ -d $1 ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi

}


verifyDir() {

  if [ ! -d $1 ]; then
    textRed "----------------> PLEASE CHECK DOMAIN AGAIN"
    exit
  fi

}


updateSystem() {

  textYellow "----------------> UPDATE SYSTEM"

  sudo apt-get purge needrestart -y &>/dev/null

  sudo apt autoremove -y &>/dev/null

  sudo apt update -y &>/dev/null

  textYellow "----------------> UPGRADE SYSTEM"

  sudo apt upgrade -y &>/dev/null

  textYellow "----------------> INSTALL DEFAULT SYSTEM"

  sudo apt install snapd -y &>/dev/null

  sudo apt install zip unzip -y &>/dev/null

  textYellow "----------------> AUTO CLEAN SYSTEM"

  sudo apt autoremove -y &>/dev/null

  sudo apt autoclean -y &>/dev/null

}

disableFirewall(){
    textYellow "----------------> DISABLE FIREWALL"
    sudo ufw disable

}
